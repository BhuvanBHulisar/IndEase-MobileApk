import React from 'react';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import { createStackNavigator } from '@react-navigation/stack';
import { RFValue } from 'react-native-responsive-fontsize';
import TabBarIcon from './TabBarIcon';
import colors from '../constants/colors';

// Screens
import HomeScreen from '../screens/home/HomeScreen';
import MachinesScreen from '../screens/machines/MachinesScreen';
import MachineFormScreen from '../screens/machines/MachineFormScreen';
import RequestsScreen from '../screens/requests/RequestsScreen';
import RequestDetailsScreen from '../screens/requests/RequestDetailsScreen';
import CreateRequestScreen from '../screens/requests/CreateRequestScreen';
import ViewQuotesScreen from '../screens/requests/ViewQuotesScreen';
import ChatListScreen from '../screens/chat/ChatListScreen';
import ChatScreen from '../screens/chat/ChatScreen';
import PaymentScreen from '../screens/payment/PaymentScreen';
import ProfileScreen from '../screens/profile/ProfileScreen';
import NotificationsScreen from '../screens/notifications/NotificationsScreen';

const Tab = createBottomTabNavigator();
const Stack = createStackNavigator();

const HomeStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="HomeMain" component={HomeScreen} />
    <Stack.Screen name="CreateRequest" component={CreateRequestScreen} />
    <Stack.Screen name="RequestDetails" component={RequestDetailsScreen} />
    <Stack.Screen name="ViewQuotes" component={ViewQuotesScreen} />
    <Stack.Screen name="Payment" component={PaymentScreen} />
    <Stack.Screen name="Chat" component={ChatScreen} />
    <Stack.Screen name="Notifications" component={NotificationsScreen} />
  </Stack.Navigator>
);

const MachinesStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="MachinesMain" component={MachinesScreen} />
    <Stack.Screen name="MachineForm" component={MachineFormScreen} />
    <Stack.Screen name="CreateRequest" component={CreateRequestScreen} />
  </Stack.Navigator>
);

const RequestsStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="RequestsMain" component={RequestsScreen} />
    <Stack.Screen name="RequestDetails" component={RequestDetailsScreen} />
    <Stack.Screen name="ViewQuotes" component={ViewQuotesScreen} />
    <Stack.Screen name="Payment" component={PaymentScreen} />
    <Stack.Screen name="Chat" component={ChatScreen} />
    <Stack.Screen name="CreateRequest" component={CreateRequestScreen} />
  </Stack.Navigator>
);

const ChatStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="ChatListMain" component={ChatListScreen} />
    <Stack.Screen name="Chat" component={ChatScreen} />
  </Stack.Navigator>
);

const ProfileStack = () => (
  <Stack.Navigator screenOptions={{ headerShown: false }}>
    <Stack.Screen name="ProfileMain" component={ProfileScreen} />
    <Stack.Screen name="Notifications" component={NotificationsScreen} />
  </Stack.Navigator>
);

const MainNavigator = () => {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.textSecondary,
        tabBarStyle: {
          height: 60,
          paddingBottom: 8,
          paddingTop: 8,
          borderTopWidth: 1,
          borderTopColor: colors.border,
        },
        tabBarLabelStyle: {
          fontSize: RFValue(11),
          fontWeight: '600',
        },
      }}
    >
      <Tab.Screen
        name="Home"
        component={HomeStack}
        options={{
          tabBarIcon: ({ focused, color }) => (
            <TabBarIcon name="home" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Machines"
        component={MachinesStack}
        options={{
          tabBarIcon: ({ focused, color }) => (
            <TabBarIcon name="construct" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Requests"
        component={RequestsStack}
        options={{
          tabBarIcon: ({ focused, color }) => (
            <TabBarIcon name="document-text" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Chats"
        component={ChatStack}
        options={{
          tabBarIcon: ({ focused, color }) => (
            <TabBarIcon name="chatbubbles" focused={focused} color={color} />
          ),
        }}
      />
      <Tab.Screen
        name="Profile"
        component={ProfileStack}
        options={{
          tabBarIcon: ({ focused, color }) => (
            <TabBarIcon name="person" focused={focused} color={color} />
          ),
        }}
      />
    </Tab.Navigator>
  );
};

export default MainNavigator;
