import React, { createContext, useState, useEffect, useContext } from 'react';
import * as requestService from '../services/requestService';
import {
  subscribeToRequestUpdates,
  subscribeToQuotes,
  subscribeToPendingConfirmation,
} from '../socket/socketService';
import { useAuth } from './AuthContext';

const RequestContext = createContext();

export const RequestProvider = ({ children }) => {
  const [requests, setRequests] = useState([]);
  const [refreshing, setRefreshing] = useState(false);
  const [loading, setLoading] = useState(true);
  const { user } = useAuth();

  useEffect(() => {
    if (user) {
      fetchRequests();
      setupSocketListeners();
    }
  }, [user]);

  const setupSocketListeners = () => {
    subscribeToRequestUpdates((data) => {
      updateRequestStatus(data.requestId, data.status);
    });

    subscribeToQuotes((data) => {
      updateRequestStatus(data.requestId, 'quote_submitted');
    });

    subscribeToPendingConfirmation((data) => {
      updateRequestStatus(data.requestId, 'pending_confirmation');
    });
  };

  const fetchRequests = async () => {
    try {
      setLoading(true);
      const data = await requestService.getMyRequests();
      setRequests(data);
    } catch (error) {
      console.error('Error fetching requests:', error);
    } finally {
      setLoading(false);
      setRefreshing(false);
    }
  };

  const updateRequestStatus = (requestId, status) => {
    setRequests((prev) =>
      prev.map((req) =>
        req._id === requestId || req.id === requestId
          ? { ...req, status }
          : req
      )
    );
  };

  const addRequest = (newRequest) => {
    setRequests((prev) => [newRequest, ...prev]);
  };

  const refresh = () => {
    setRefreshing(true);
    fetchRequests();
  };

  const activeRequests = requests.filter(
    (req) => !['completed', 'cancelled'].includes(req.status)
  );

  return (
    <RequestContext.Provider
      value={{
        requests,
        activeRequests,
        loading,
        refreshing,
        fetchRequests,
        addRequest,
        refresh,
        updateRequestStatus,
      }}
    >
      {children}
    </RequestContext.Provider>
  );
};

export const useRequests = () => {
  const context = useContext(RequestContext);
  if (!context) {
    throw new Error('useRequests must be used within RequestProvider');
  }
  return context;
};

export default RequestContext;
