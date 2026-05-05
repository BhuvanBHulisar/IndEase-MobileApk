import React from 'react';
import Icon from 'react-native-vector-icons/Ionicons';

const TabBarIcon = ({ name, focused, color, size = 24 }) => {
  const iconName = focused ? name : `${name}-outline`;
  return <Icon name={iconName} size={size} color={color} />;
};

export default TabBarIcon;
