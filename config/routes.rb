Rails.application.routes.draw do
  get '/stocks/:ticker_symbol', to: 'stocks#show'
  get '/stocks/stock/:ticker_symbol', to: 'stocks#stock'
  resources :stocks
  resources :stock_prices
end
