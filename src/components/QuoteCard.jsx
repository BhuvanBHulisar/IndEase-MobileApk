import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Card from './Card';
import Button from './Button';
import colors from '../constants/colors';
import { formatCurrency } from '../utils/formatters';

const QuoteCard = ({ quote, onApprove, onAskQuestion }) => {
  const expert = quote.expert || quote.producer;
  const totalAmount = quote.amount || (quote.labour_cost + quote.parts_cost);

  return (
    <Card style={styles.card}>
      <View style={styles.header}>
        <View style={styles.avatarContainer}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>
              {expert?.firstName?.[0] || 'E'}
            </Text>
          </View>
          <View style={styles.expertInfo}>
            <Text style={styles.expertName}>
              {expert?.firstName} {expert?.lastName}
            </Text>
            <View style={styles.ratingRow}>
              <Text style={styles.rating}>⭐ {expert?.rating || '4.5'}</Text>
              <Text style={styles.level}>• {expert?.level || 'Expert'}</Text>
              <Text style={styles.jobs}>
                • {expert?.completedJobs || 0} jobs
              </Text>
            </View>
          </View>
        </View>
      </View>

      {quote.diagnosis_note && (
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Assessment</Text>
          <Text style={styles.sectionText}>{quote.diagnosis_note}</Text>
        </View>
      )}

      {quote.scope_of_work && (
        <View style={styles.section}>
          <Text style={styles.sectionTitle}>Scope of Work</Text>
          <Text style={styles.sectionText}>{quote.scope_of_work}</Text>
        </View>
      )}

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Cost Breakdown</Text>
        <View style={styles.costRow}>
          <Text style={styles.costLabel}>Labour</Text>
          <Text style={styles.costValue}>
            {formatCurrency(quote.labour_cost)}
          </Text>
        </View>
        <View style={styles.costRow}>
          <Text style={styles.costLabel}>Parts</Text>
          <Text style={styles.costValue}>
            {formatCurrency(quote.parts_cost)}
          </Text>
        </View>
        <View style={[styles.costRow, styles.totalRow]}>
          <Text style={styles.totalLabel}>Total</Text>
          <Text style={styles.totalValue}>
            {formatCurrency(totalAmount)}
          </Text>
        </View>
      </View>

      <View style={styles.detailsRow}>
        <View style={styles.detailItem}>
          <Text style={styles.detailLabel}>Estimated Hours</Text>
          <Text style={styles.detailValue}>
            {quote.estimated_hours || 'N/A'}
          </Text>
        </View>
        <View style={styles.detailItem}>
          <Text style={styles.detailLabel}>Available</Text>
          <Text style={styles.detailValue}>
            {quote.available_date || 'Flexible'}
          </Text>
        </View>
        <View style={styles.detailItem}>
          <Text style={styles.detailLabel}>Visit Type</Text>
          <Text style={styles.detailValue}>
            {quote.visit_type || 'On-site'}
          </Text>
        </View>
      </View>

      <View style={styles.actions}>
        <Button
          title={`Approve & Pay ${formatCurrency(totalAmount)}`}
          variant="primary"
          onPress={() => onApprove(quote)}
          style={styles.approveButton}
        />
        <Button
          title="Ask a Question"
          variant="secondary"
          onPress={() => onAskQuestion(quote)}
          style={styles.questionButton}
        />
      </View>
    </Card>
  );
};

const styles = StyleSheet.create({
  card: {
    marginBottom: wp('4%'),
  },
  header: {
    marginBottom: wp('4%'),
  },
  avatarContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  avatar: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: wp('3%'),
  },
  avatarText: {
    fontSize: RFValue(18),
    fontWeight: 'bold',
    color: '#ffffff',
  },
  expertInfo: {
    flex: 1,
  },
  expertName: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  ratingRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  rating: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
  },
  level: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    marginLeft: wp('2%'),
  },
  jobs: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    marginLeft: wp('2%'),
  },
  section: {
    marginBottom: wp('4%'),
  },
  sectionTitle: {
    fontSize: RFValue(13),
    fontWeight: '600',
    color: colors.textPrimary,
    marginBottom: wp('2%'),
  },
  sectionText: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
    lineHeight: RFValue(18),
  },
  costRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: wp('2%'),
  },
  costLabel: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
  },
  costValue: {
    fontSize: RFValue(13),
    color: colors.textPrimary,
    fontWeight: '500',
  },
  totalRow: {
    borderTopWidth: 1,
    borderTopColor: colors.border,
    paddingTop: wp('2%'),
    marginTop: wp('1%'),
  },
  totalLabel: {
    fontSize: RFValue(15),
    fontWeight: '700',
    color: colors.textPrimary,
  },
  totalValue: {
    fontSize: RFValue(15),
    fontWeight: '700',
    color: colors.primary,
  },
  detailsRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: wp('4%'),
  },
  detailItem: {
    flex: 1,
    alignItems: 'center',
  },
  detailLabel: {
    fontSize: RFValue(11),
    color: colors.textSecondary,
    marginBottom: wp('1%'),
  },
  detailValue: {
    fontSize: RFValue(12),
    fontWeight: '600',
    color: colors.textPrimary,
  },
  actions: {
    gap: wp('2%'),
  },
  approveButton: {
    marginBottom: wp('2%'),
  },
  questionButton: {},
});

export default QuoteCard;
