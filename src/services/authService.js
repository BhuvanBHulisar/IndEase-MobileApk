import api from './api';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { TOKEN_KEY } from '../constants/api';

export const login = async (email, password) => {
  const response = await api.post('/auth/login', { email, password });
  if (response.data.token) {
    await AsyncStorage.setItem(TOKEN_KEY, response.data.token);
  }
  return response.data;
};

export const register = async (userData) => {
  const response = await api.post('/auth/register', {
    ...userData,
    role: 'consumer',
  });
  if (response.data.token) {
    await AsyncStorage.setItem(TOKEN_KEY, response.data.token);
  }
  return response.data;
};

export const googleLogin = async (token) => {
  const response = await api.post('/auth/google', { token });
  if (response.data.token) {
    await AsyncStorage.setItem(TOKEN_KEY, response.data.token);
  }
  return response.data;
};

export const getCurrentUser = async () => {
  const response = await api.get('/auth/me');
  return response.data;
};

export const logout = async () => {
  await AsyncStorage.removeItem(TOKEN_KEY);
};

export const getStoredToken = async () => {
  return await AsyncStorage.getItem(TOKEN_KEY);
};

export const updateProfile = async (profileData) => {
  const response = await api.put('/users/profile', profileData);
  return response.data;
};

export const uploadAvatar = async (imageUri) => {
  const formData = new FormData();
  formData.append('avatar', {
    uri: imageUri,
    type: 'image/jpeg',
    name: 'avatar.jpg',
  });
  
  const response = await api.post('/users/avatar', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
  return response.data;
};
