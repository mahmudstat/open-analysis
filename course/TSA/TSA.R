
install.packages("forecast")
library(forecast)

library(ggplot2)

# Fit SARIMAX model (Not runable)
model <- Arima(y,
               order = c(p, d, q),           # non-seasonal ARIMA order
               seasonal = c(P, D, Q, S),     # seasonal order (S = period)
               xreg = xreg_data)             # exogenous variables

# Runable code

# Create sample data

set.seed(123)
n <- 120
time <- 1:n

# Main time series with trend + seasonality
y <- 50 + 0.3*time + 10*sin(2*pi*time/12) + rnorm(n, 0, 5)

# External variable (e.g., marketing spend)
x1 <- 20 + 0.1*time + rnorm(n, 0, 3)

# Convert to time series object
y_ts <- ts(y, frequency = 12)
x1_ts <- ts(x1, frequency = 12)

# Fit SARIMAX model
# Try simpler model first
sarimax_model <- Arima(y_ts, 
                       order = c(1, 1, 0),      # Remove MA term
                       seasonal = c(1, 1, 0),   # Remove seasonal MA
                       xreg = x1_ts)

summary(sarimax_model)

# Let R find optimal parameters
sarimax_model <- auto.arima(y_ts, 
                            seasonal = TRUE,
                            stepwise = TRUE,
                            approximation = TRUE,
                            xreg = x1_ts)

# Add second external variable
x2 <- 15 + 0.05*time + rnorm(n, 0, 2)
xreg_matrix <- cbind(x1_ts, x2_ts)

# Fit model with multiple external variables
sarimax_model2 <- Arima(y_ts,
                        order = c(1, 1, 1),
                        seasonal = c(1, 1, 1),
                        xreg = xreg_matrix)

summary(sarimax_model2)