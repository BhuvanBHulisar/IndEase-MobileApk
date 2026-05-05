import io from 'socket.io-client';
import { SOCKET_URL } from '../constants/api';

let socket = null;

export const connectSocket = (token, userId) => {
  if (socket?.connected) {
    return socket;
  }

  socket = io(SOCKET_URL, {
    query: { token },
    transports: ['websocket'],
    reconnection: true,
    reconnectionDelay: 1000,
    reconnectionAttempts: 5,
  });

  socket.on('connect', () => {
    console.log('Socket connected');
    socket.emit('join', userId);
  });

  socket.on('disconnect', () => {
    console.log('Socket disconnected');
  });

  socket.on('error', (error) => {
    console.error('Socket error:', error);
  });

  return socket;
};

export const subscribeToRequestUpdates = (callback) => {
  socket?.on('request_status_updated', callback);
};

export const subscribeToQuotes = (callback) => {
  socket?.on('quote_received', callback);
};

export const subscribeToPendingConfirmation = (callback) => {
  socket?.on('job_pending_confirmation', callback);
};

export const subscribeToMessages = (callback) => {
  socket?.on('new_message', callback);
};

export const subscribeToInvoice = (callback) => {
  socket?.on('invoice_received', callback);
};

export const sendMessage = (chatId, content) => {
  socket?.emit('send_message', { chatId, content });
};

export const unsubscribeAll = () => {
  socket?.off('request_status_updated');
  socket?.off('quote_received');
  socket?.off('job_pending_confirmation');
  socket?.off('new_message');
  socket?.off('invoice_received');
};

export const disconnectSocket = () => {
  if (socket) {
    unsubscribeAll();
    socket.disconnect();
    socket = null;
  }
};

export const getSocket = () => socket;
