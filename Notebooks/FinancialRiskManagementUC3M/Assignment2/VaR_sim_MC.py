import numpy as np;
import pandas as pd;

DIAS_CHOL = 6001;
SAMPLES_MC = 5000;
PORTFOLIO_SIZE = 1_000_000;
WEIGHTS = PORTFOLIO_SIZE * np.array([0.2, 0.1, 0.15, 0.35, 0.2]);
CONF_LEVEL = 0.95;

"""

sample_t_5ddof = np.random.standard_t(df = 1, size = (SAMPLES_MC, 5)) @ chol_mat;
    sample_t_5ddof = np.exp(sample_t_5ddof * volatility);
    sample_t_5ddof = np.sum(sample_t_5ddof * WEIGHTS, axis = 1);

"""
def monte_carlo_sim_normal(volatility : np.ndarray, chol_mat : np.ndarray):
    """
        Crea una simulación de monte carlo de tamaño especificado por la constante
        global 'SAMPLES_MC' usando una distribución normal estándar y un array
        de volatilidades con un método de tres pasos:

        Paso 1: Calcular Zv = Matriz_de_Cholesky x (Y1, Y2, ...)' 

        Paso 2: Calcular rendimientos simulados = e^(Zv * volatilidades)

        Paso 3: Obtener la muestra de pérdidas simuladas como la suma ponderada de los 
        rendimientos simulados
    """

    global SAMPLES_MC;
    global WEIGHTS;

    sample_normal = np.random.standard_normal(size = (SAMPLES_MC, 5)) @ chol_mat;
    sample_normal = np.exp(sample_normal * volatility);
    sample_normal = np.sum(sample_normal * WEIGHTS, axis = 1);

    return sample_normal;

def monte_carlo_sim_student_t(volatility : np.ndarray, chol_mat : np.ndarray, ddof : int):
    """
        Crea una simulación de monte carlo de tamaño especificado por la constante
        global 'SAMPLES_MC' usando una distribución normal estándar y un array
        de volatilidades con un método de tres pasos:

        Paso 1: Calcular Zv = Matriz_de_Cholesky x (Y1, Y2, ...)' 

        Paso 2: Calcular rendimientos simulados = e^(Zv * volatilidades)
        
        Paso 3: Obtener la muestra de pérdidas simuladas como la suma ponderada de los 
        rendimientos simulados
    """

    global SAMPLES_MC;
    global WEIGHTS;

    sample_t = np.random.standard_t(df = ddof, size = (SAMPLES_MC, 5)) @ chol_mat;
    sample_t = np.exp(sample_t * volatility);
    sample_t = np.sum(sample_t * WEIGHTS, axis = 1);

    return sample_t;

def five_dist_var(volatilities : np.ndarray, chol_mat : np.ndarray):

    global PORTFOLIO_SIZE;
    global CONF_LEVEL;

    var_row = np.column_stack((
        monte_carlo_sim_student_t(volatilities, chol_mat, 1) - PORTFOLIO_SIZE,

        monte_carlo_sim_student_t(volatilities, chol_mat, 2) - PORTFOLIO_SIZE,

        monte_carlo_sim_student_t(volatilities, chol_mat, 5) - PORTFOLIO_SIZE,

        monte_carlo_sim_student_t(volatilities, chol_mat, 10) - PORTFOLIO_SIZE,

        monte_carlo_sim_normal(volatilities, chol_mat) - PORTFOLIO_SIZE
    ));

    return np.round(np.quantile(var_row, 1 - CONF_LEVEL, axis = 0), 2);

vol_data = pd.read_csv("C:\\Users\\goomb\\Documents\\Datasets\\FinancialRiskManagement\\Assignment2\\VolData.csv",
                   date_format ="mm/dd/yy", index_col= "Date");

ch_data = pd.read_csv("C:\\Users\\goomb\\Documents\\Datasets\\FinancialRiskManagement\\Assignment2\\CloseData.csv",
                        date_format = "mm/dd/yy", index_col= "Date");

# Calcula cambios con respecto al día anterior, reusamos las mismas columnas por simplicidad
ch_data["Close_intel"] = np.log(ch_data["Close_intel"].shift(1)/ch_data["Close_intel"]);
ch_data["Close_exxon"] = np.log(ch_data["Close_exxon"].shift(1)/ch_data["Close_exxon"]);
ch_data["Close_jpmorgan"] = np.log(ch_data["Close_jpmorgan"].shift(1)/ch_data["Close_jpmorgan"]);
ch_data["Close_microsoft"] = np.log(ch_data["Close_microsoft"].shift(1)/ch_data["Close_microsoft"]);
ch_data["Close_pfizer"] = np.log(ch_data["Close_pfizer"].shift(1)/ch_data["Close_pfizer"]);


ch_data.drop(["Close_us500"], axis = 1, inplace = True); # No necesitamos el S&P500 en este caso
ch_data.drop(["2000-03-30"], axis = 0, inplace = True); # Esta fila tiene valores faltantes


corr_mat = ch_data.iloc[-DIAS_CHOL:, :].corr();
chol_mat = np.linalg.cholesky(corr_mat);
print(five_dist_var(np.array(vol_data.iloc[-1, 1:]).flatten(), chol_mat))
#test = monte_carlo_sim_student_t(np.array(vol_data.iloc[-1, 1:]).flatten(), chol_mat, 1) - PORTFOLIO_SIZE
#print(np.quantile(test, 0.05))

