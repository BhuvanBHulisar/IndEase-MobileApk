import api from './api';

export const getMyRequests = async () => {
  const response = await api.get('/jobs/my-requests');
  return response.data;
};

export const createRequest = async (requestData) => {
  const response = await api.post('/jobs/broadcast', requestData);
  return response.data;
};

export const getRequestById = async (id) => {
  const response = await api.get(`/jobs/${id}`);
  return response.data;
};

export const getQuotes = async (requestId) => {
  const response = await api.get(`/jobs/${requestId}/quotes`);
  return response.data;
};

export const approveQuote = async (requestId, quoteId) => {
  const response = await api.post(`/jobs/${requestId}/quotes/${quoteId}/approve`);
  return response.data;
};

export const cancelRequest = async (requestId) => {
  const response = await api.patch(`/jobs/${requestId}/cancel`);
  return response.data;
};

export const confirmComplete = async (requestId) => {
  const response = await api.patch(`/jobs/${requestId}/confirm-complete`);
  return response.data;
};

export const createFollowUp = async (requestId, description) => {
  const response = await api.post(`/jobs/${requestId}/follow-up`, { description });
  return response.data;
};

export const rateExpert = async (ratingData) => {
  const response = await api.post('/ratings', ratingData);
  return response.data;
};
