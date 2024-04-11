import pandas as pd;
import numpy as np;

"""
    Usaremos estas constantes para calcular el VaR al 95% con una cartera de 1_000_000;
    de querer editar el resultado, esto permite hacerlo con facilidad.
"""
CONF_095 = 1.644854;
TOTAL_CARTERA = 1_000_000;

# Para simplificar los cálculos convertiremos los pesos de cada empresa en la cartera en una matriz 5x1
alphas = np.array([0.2, 0.1, 0.15, 0.35, 0.2]);
alphas = np.reshape(alphas, (5, 1));

def value_at_risk(quantity, volatility, time, Z):
    """
    Calcula el VaR simple a través del producto de la volatilidad diaria, el valor monetario
    de la cartera, el tiempo y el nivel de confianza.
    """
    
    return (quantity * volatility * np.sqrt(time) * Z);


def diversified_var(col_vector_P : np.ndarray, corrmat : np.ndarray):
    """
    Calcula el VaR diversificado de varios activos usando operaciones matriciales
    de los vectores de VaR y la matriz de correlaciones.
    """
    
    return np.sqrt(col_vector_P.T @ corrmat @ col_vector_P)[0, 0];


def varBeta(beta_vector : np.ndarray, alpha_vec : np.ndarray, quantity, market_vol, time, Z):
    """
    Calcula el VaRBeta de una cartera de activos a través la volatilidad de la cartera, siendo
    esta calculada a través de la obtención de la matriz decovarianzas. Cabe destacar que el único
    factor de riesgo a considerar en este caso es el riesgo sistemático (de mercado).
    """

    cov_mat = (beta_vector @ beta_vector.T) * (market_vol ** 2);
    vol = np.sqrt(alpha_vec.T @ cov_mat @ alpha_vec);

    return (vol * quantity * np.sqrt(time) * Z)[0, 0];





vol_data = pd.read_csv("C:\\Users\\goomb\\Documents\\Datasets\\FinancialRiskManagement\\Assignment2\\VolData.csv",
                   date_format ="mm/dd/yy", index_col= "Date");

ch_data=pd.read_csv("C:\\Users\\goomb\\Documents\\Datasets\\FinancialRiskManagement\\Assignment2\\CloseData.csv",
                        date_format ="mm/dd/yy", index_col= "Date");

# Calculamos los cambios con respecto al día anterior
ch_data["Close_intel"] = np.log(ch_data["Close_intel"].shift(1)/ch_data["Close_intel"]).dropna();
ch_data["Close_exxon"] = np.log(ch_data["Close_exxon"].shift(1)/ch_data["Close_exxon"]).dropna();
ch_data["Close_jpmorgan"] = np.log(ch_data["Close_jpmorgan"].shift(1)/ch_data["Close_jpmorgan"]).dropna();
ch_data["Close_microsoft"] = np.log(ch_data["Close_microsoft"].shift(1)/ch_data["Close_microsoft"]).dropna();
ch_data["Close_pfizer"] = np.log(ch_data["Close_pfizer"].shift(1)/ch_data["Close_pfizer"]).dropna();
ch_data["Close_us500"] = np.log(ch_data["Close_us500"].shift(1)/ch_data["Close_us500"]).dropna();

corr_mat = np.array(ch_data.iloc[:, 1:].corr(), dtype = "float32");

"""
    Al coger las volatilidades calculadas con una ventana de 60 días,
    no vamos a tener en cuenta la del S&P500 ya que este vector lo usaremos 
    para calcular fácilmente el vector P, que ya contiene los VaRes individuales
"""
last_day_vols = np.reshape(np.array(vol_data.iloc[-1, 1:]), (5, 1)); 
vector_P = value_at_risk(TOTAL_CARTERA * alphas, last_day_vols, 1, CONF_095);

var_no_diversificado = np.sum(vector_P);
var_diversificado = diversified_var(vector_P, corr_mat);


betas = np.zeros((5, 1));
market_change_data = np.array(ch_data.iloc[-365:, 0]);
market_var = np.var(market_change_data)

for i in range(1,6,1):

    stock_data = np.array(ch_data.iloc[-365:, i]);

    both = np.vstack((stock_data, market_change_data));
    betas[i - 1, 0] = np.cov(both)[0, 1] / market_var;

var_beta = varBeta(betas, alphas, TOTAL_CARTERA, vol_data.iloc[-1, 0], 1, CONF_095);    
   
print("VaRes individuales: ", vector_P[:, 0], "\nVaR no diversificado: ", var_no_diversificado,
       "\nVaR diversificado: ", var_diversificado, "\nVaR beta: ", var_beta);
