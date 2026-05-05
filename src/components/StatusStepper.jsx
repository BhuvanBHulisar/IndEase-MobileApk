import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import colors from '../constants/colors';
import { getProgressStep } from '../utils/statusHelpers';

const StatusStepper = ({ status }) => {
  const currentStep = getProgressStep(status);
  const steps = ['Submitted', 'Quote', 'In Progress', 'Done'];

  return (
    <View style={styles.container}>
      {steps.map((step, index) => (
        <React.Fragment key={index}>
          <View style={styles.stepContainer}>
            <View
              style={[
                styles.circle,
                index <= currentStep && styles.circleActive,
              ]}
            >
              {index < currentStep && (
                <Text style={styles.checkmark}>✓</Text>
              )}
            </View>
            <Text
              style={[
                styles.label,
                index <= currentStep && styles.labelActive,
              ]}
            >
              {step}
            </Text>
          </View>
          {index < steps.length - 1 && (
            <View
              style={[
                styles.line,
                index < currentStep && styles.lineActive,
              ]}
            />
          )}
        </React.Fragment>
      ))}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: wp('4%'),
  },
  stepContainer: {
    alignItems: 'center',
  },
  circle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: colors.border,
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: wp('1%'),
  },
  circleActive: {
    backgroundColor: colors.primary,
  },
  checkmark: {
    color: '#ffffff',
    fontSize: RFValue(14),
    fontWeight: 'bold',
  },
  label: {
    fontSize: RFValue(10),
    color: colors.textSecondary,
    textAlign: 'center',
  },
  labelActive: {
    color: colors.primary,
    fontWeight: '600',
  },
  line: {
    flex: 1,
    height: 2,
    backgroundColor: colors.border,
    marginHorizontal: wp('1%'),
    marginBottom: wp('6%'),
  },
  lineActive: {
    backgroundColor: colors.primary,
  },
});

export default StatusStepper;
