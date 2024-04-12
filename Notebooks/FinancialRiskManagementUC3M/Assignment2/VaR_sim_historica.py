import pandas as pd;
import numpy as np;

"""
    Estas constantes te permiten cambiar los parámetros del VaR con falicidad, la serie histórica
    entera que se puede usar es de 6001 miembros así que cualquier número mayor lanzará un error, de
    la misma manera que el resto de los parámetros deben ser verosímiles
"""
NIVEL_CONF = 0.95;
TOTAL_CARTERA = 1_000_000;
DIAS_SIM_HISTORICA = 6001;
ALPHAS = np.array([0.2, 0.1, 0.15, 0.35, 0.2]);

assert (TOTAL_CARTERA >= 0), "El valor de la cartera debe ser positivo"; 
assert (NIVEL_CONF > 0 and NIVEL_CONF < 1), "El nivel de confianza debe estar entre (0, 1)";
assert (DIAS_SIM_HISTORICA < 6002 and DIAS_SIM_HISTORICA > 0), "La serie histórica dura 6001 días";


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


Var_data_scenarios = np.sum(ch_data.iloc[:, -DIAS_SIM_HISTORICA:] * TOTAL_CARTERA * ALPHAS, axis = 1);
VaR = round(abs(np.quantile(Var_data_scenarios, 1 - NIVEL_CONF)), 2);

"""
    El VaR con los parámetros:
    DIAS_SIM_HISTORICA = 6001 (Toda la serie)
    ALPHAS = [0.2, 0.1, 0.15, 0.35, 0.2]
    TOTAL_CARTERA = 1_000_000
    NIVEL_CONF = 0.95

    Es igual a 21394.26$
"""
print(f"El VaR por simulación histórica al 95% de confianza es: {VaR}$");

