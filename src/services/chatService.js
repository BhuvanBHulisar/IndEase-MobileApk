import api from './api';

export const getChats = async () => {
  const response = await api.get('/chats');
  return response.data;
};

export const getMessages = async (chatId) => {
  const response = await api.get(`/chats/${chatId}/messages`);
  return response.data;
};

export const sendMessage = async (chatId, content) => {
  const response = await api.post(`/chats/${chatId}/messages`, { content });
  return response.data;
};
