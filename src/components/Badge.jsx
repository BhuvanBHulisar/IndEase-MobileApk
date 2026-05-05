import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import { getStatusLabel, getStatusColor } from '../utils/statusHelpers';

const Badge = ({ status, pulse = false }) => {
  const color = getStatusColor(status);
  const label = getStatusLabel(status);

  return (
    <View style={[styles.badge, { backgroundColor: `${color}20` }]}>
      {pulse && <View style={[styles.pulse, { backgroundColor: color }]} />}
      <Text style={[styles.text, { color }]}>{label}</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  badge: {
    paddingHorizontal: wp('3%'),
    paddingVertical: wp('1.5%'),
    borderRadius: 8,
    flexDirection: 'row',
    alignItems: 'center',
    alignSelf: 'flex-start',
  },
  text: {
    fontSize: RFValue(11),
    fontWeight: '600',
  },
  pulse: {
    width: 8,
    height: 8,
    borderRadius: 4,
    marginRight: wp('2%'),
  },
});

export default Badge;
