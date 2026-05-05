import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import Button from './Button';
import colors from '../constants/colors';

const EmptyState = ({ icon, title, message, actionLabel, onAction }) => {
  return (
    <View style={styles.container}>
      <Icon name={icon} size={80} color={colors.border} />
      <Text style={styles.title}>{title}</Text>
      <Text style={styles.message}>{message}</Text>
      {actionLabel && onAction && (
        <Button
          title={actionLabel}
          onPress={onAction}
          fullWidth={false}
          style={styles.button}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: wp('8%'),
  },
  title: {
    fontSize: RFValue(18),
    fontWeight: '700',
    color: colors.textPrimary,
    marginTop: wp('4%'),
    marginBottom: wp('2%'),
  },
  message: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    textAlign: 'center',
    lineHeight: RFValue(20),
    marginBottom: wp('6%'),
  },
  button: {
    paddingHorizontal: wp('8%'),
  },
});

export default EmptyState;
