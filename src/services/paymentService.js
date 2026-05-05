import api from './api';

export const createOrder = async (amount, requestId) => {
  const response = await api.post('/payments/create-order', { amount, requestId });
  return response.data;
};

export const verifyPayment = async (paymentData) => {
  const response = await api.post('/payments/verify', paymentData);
  return response.data;
};
