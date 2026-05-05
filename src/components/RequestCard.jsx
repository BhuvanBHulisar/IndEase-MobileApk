import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Card from './Card';
import Badge from './Badge';
import StatusStepper from './StatusStepper';
import Button from './Button';
import colors from '../constants/colors';
import { truncateText, getTimeAgo } from '../utils/formatters';
import { getActionButton } from '../utils/statusHelpers';

const RequestCard = ({ request, onPress, onActionPress }) => {
  const actionButton = getActionButton(request.status);

  return (
    <TouchableOpacity onPress={onPress} activeOpacity={0.9}>
      <Card style={styles.card}>
        <View style={styles.header}>
          <Text style={styles.machineName}>
            {request.machine?.name || 'Machine'}
          </Text>
          <Badge
            status={request.status}
            pulse={request.status === 'quote_submitted'}
          />
        </View>

        <Text style={styles.issue}>
          {truncateText(request.issueDescription, 80)}
        </Text>

        <StatusStepper status={request.status} />

        <View style={styles.footer}>
          <Text style={styles.time}>
            {getTimeAgo(request.createdAt || request.created_at)}
          </Text>
          {actionButton && (
            <Button
              title={actionButton.label}
              variant={actionButton.type}
              onPress={() => onActionPress(request)}
              fullWidth={false}
              style={styles.actionButton}
            />
          )}
        </View>
      </Card>
    </TouchableOpacity>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: wp('4%'),
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: wp('2%'),
  },
  machineName: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    flex: 1,
  },
  issue: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
    marginBottom: wp('3%'),
    lineHeight: RFValue(18),
  },
  footer: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginTop: wp('2%'),
  },
  time: {
    fontSize: RFValue(11),
    color: colors.textSecondary,
  },
  actionButton: {
    paddingHorizontal: wp('4%'),
    height: 36,
  },
});

export default RequestCard;
