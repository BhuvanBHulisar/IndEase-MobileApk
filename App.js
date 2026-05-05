import React from 'react';
import { StatusBar } from 'react-native';
import { SafeAreaProvider } from 'react-native-safe-area-context';
import { AuthProvider } from './src/context/AuthContext';
import { NotificationProvider } from './src/context/NotificationContext';
import { RequestProvider } from './src/context/RequestContext';
import AppNavigator from './src/navigation/AppNavigator';

const App = () => {
  return (
    <SafeAreaProvider>
      <AuthProvider>
        <RequestProvider>
          <NotificationProvider>
            <StatusBar barStyle="dark-content" backgroundColor="#ffffff" />
            <AppNavigator />
          </NotificationProvider>
        </RequestProvider>
      </AuthProvider>
    </SafeAreaProvider>
  );
};

export default App;