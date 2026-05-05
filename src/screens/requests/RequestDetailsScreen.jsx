import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
  Alert,
  Linking,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import Icon from 'react-native-vector-icons/Ionicons';
import Card from '../../components/Card';
import Badge from '../../components/Badge';
import Button from '../../components/Button';
import Header from '../../components/Header';
import LoadingSpinner from '../../components/LoadingSpinner';
import Toast from '../../components/Toast';
import { getRequestById, cancelRequest, confirmComplete } from '../../services/requestService';
import { useRequests } from '../../context/RequestContext';
import colors from '../../constants/colors';
import { formatDate, formatCurrency } from '../../utils/formatters';
import { getActionButton } from '../../utils/statusHelpers';

const RequestDetailsScreen = ({ navigation, route }) => {
  const { requestId } = route.params;
  const { updateRequestStatus } = useRequests();
  const [request, setRequest] = useState(null);
  const [loading, setLoading] = useState(true);
  const [actionLoading, setActionLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  useEffect(() => {
    loadRequest();
  }, [requestId]);

  const loadRequest = async () => {
    try {
      setLoading(true);
      const data = await getRequestById(requestId);
      setRequest(data);
    } catch (error) {
      setToast({
        visible: true,
        message: 'Failed to load request details',
        type: 'error',
      });
    } finally {
      setLoading(false);
    }
  };

  const handleCancel = () => {
    Alert.alert(
      'Cancel Request',
      'Are you sure you want to cancel this request?',
      [
        { text: 'No', style: 'cancel' },
        {
          text: 'Yes, Cancel',
          style: 'destructive',
          onPress: async () => {
            try {
              setActionLoading(true);
              await cancelRequest(requestId);
              updateRequestStatus(requestId, 'cancelled');
              setToast({
                visible: true,
                message: 'Request cancelled successfully',
                type: 'success',
              });
              setTimeout(() => navigation.goBack(), 1000);
            } catch (error) {
              setToast({
                visible: true,
                message: 'Failed to cancel request',
                type: 'error',
              });
            } finally {
              setActionLoading(false);
            }
          },
        },
      ]
    );
  };

  const handleConfirmComplete = () => {
    Alert.alert(
      'Confirm Completion',
      'Please confirm that the repair work has been completed satisfactorily. This will release the payment to the expert.',
      [
        { text: 'Not Yet', style: 'cancel' },
        {
          text: 'Confirm',
          onPress: async () => {
            try {
              setActionLoading(true);
              await confirmComplete(requestId);
              updateRequestStatus(requestId, 'completed');
              setToast({
                visible: true,
                message: 'Payment released! Please rate the expert.',
                type: 'success',
              });
              loadRequest();
            } catch (error) {
              setToast({
                visible: true,
                message: 'Failed to confirm completion',
                type: 'error',
              });
            } finally {
              setActionLoading(false);
            }
          },
        },
      ]
    );
  };

  const handleAction = () => {
    const action = getActionButton(request.status);
    if (!action) return;

    switch (request.status) {
      case 'broadcast':
        handleCancel();
        break;
      case 'quote_submitted':
        navigation.navigate('ViewQuotes', { requestId });
        break;
      case 'pending_confirmation':
        handleConfirmComplete();
        break;
      case 'en_route':
      case 'in_progress':
        navigation.navigate('Chat', { requestId });
        break;
      case 'completed':
        navigation.navigate('RateExpert', { requestId });
        break;
    }
  };

  const handleCallExpert = () => {
    const phone = request.expert?.phone || request.producer?.phone;
    if (phone) {
      Linking.openURL(`tel:${phone}`);
    }
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  if (!request) {
    return (
      <SafeAreaView style={styles.container}>
        <Header title="Request Details" onBack={() => navigation.goBack()} />
        <View style={styles.errorContainer}>
          <Text style={styles.errorText}>Request not found</Text>
        </View>
      </SafeAreaView>
    );
  }

  const expert = request.expert || request.producer;
  const actionButton = getActionButton(request.status);

  return (
    <SafeAreaView style={styles.container}>
      <Header title="Request Details" onBack={() => navigation.goBack()} />

      <ScrollView style={styles.scrollView} contentContainerStyle={styles.content}>
        <Card style={styles.statusCard}>
          <Badge status={request.status} pulse={request.status === 'quote_submitted'} />
          <Text style={styles.requestId}>Request #{request._id?.slice(-6) || request.id?.slice(-6)}</Text>
        </Card>

        <Card>
          <Text style={styles.sectionTitle}>Machine Details</Text>
          <View style={styles.infoRow}>
            <Icon name="construct-outline" size={20} color={colors.primary} />
            <Text style={styles.infoText}>{request.machine?.name || 'N/A'}</Text>
          </View>
          <View style={styles.infoRow}>
            <Icon name="settings-outline" size={20} color={colors.primary} />
            <Text style={styles.infoText}>{request.machine?.type || 'N/A'}</Text>
          </View>
        </Card>

        <Card>
          <Text style={styles.sectionTitle}>Issue Description</Text>
          <Text style={styles.issueText}>{request.issueDescription}</Text>
        </Card>

        {request.ai_machine_type && (
          <Card style={styles.aiCard}>
            <View style={styles.aiHeader}>
              <Icon name="sparkles" size={20} color={colors.secondary} />
              <Text style={styles.aiTitle}>AI Analysis</Text>
            </View>
            <Text style={styles.aiText}>
              <Text style={styles.aiLabel}>Machine Type: </Text>
              {request.ai_machine_type}
            </Text>
            <Text style={styles.aiText}>
              <Text style={styles.aiLabel}>Issue Summary: </Text>
              {request.ai_issue_summary}
            </Text>
            <Text style={styles.aiText}>
              <Text style={styles.aiLabel}>Confidence: </Text>
              {request.ai_confidence}%
            </Text>
          </Card>
        )}

        <Card>
          <Text style={styles.sectionTitle}>Request Details</Text>
          <View style={styles.detailRow}>
            <Text style={styles.detailLabel}>Urgency:</Text>
            <Text style={styles.detailValue}>
              {request.urgencyLevel?.toUpperCase() || 'NORMAL'}
            </Text>
          </View>
          <View style={styles.detailRow}>
            <Text style={styles.detailLabel}>Preferred Date:</Text>
            <Text style={styles.detailValue}>
              {formatDate(request.preferredDate)}
            </Text>
          </View>
          <View style={styles.detailRow}>
            <Text style={styles.detailLabel}>Time Slot:</Text>
            <Text style={styles.detailValue}>
              {request.preferredTimeSlot?.charAt(0).toUpperCase() +
                request.preferredTimeSlot?.slice(1) || 'Anytime'}
            </Text>
          </View>
          {request.consumerBudgetHint && (
            <View style={styles.detailRow}>
              <Text style={styles.detailLabel}>Budget Hint:</Text>
              <Text style={styles.detailValue}>{request.consumerBudgetHint}</Text>
            </View>
          )}
        </Card>

        {expert && (
          <Card>
            <Text style={styles.sectionTitle}>Expert Details</Text>
            <View style={styles.expertHeader}>
              <View style={styles.expertAvatar}>
                <Text style={styles.expertAvatarText}>
                  {expert.firstName?.[0] || 'E'}
                </Text>
              </View>
              <View style={styles.expertInfo}>
                <Text style={styles.expertName}>
                  {expert.firstName} {expert.lastName}
                </Text>
                <Text style={styles.expertRating}>
                  ⭐ {expert.rating || '4.5'} • {expert.level || 'Expert'}
                </Text>
              </View>
              {expert.phone && (
                <Button
                  title="Call"
                  onPress={handleCallExpert}
                  variant="secondary"
                  fullWidth={false}
                  style={styles.callButton}
                />
              )}
            </View>
          </Card>
        )}

        {actionButton && (
          <Button
            title={actionButton.label}
            onPress={handleAction}
            variant={actionButton.type}
            loading={actionLoading}
            style={styles.actionButton}
          />
        )}
      </ScrollView>

      <Toast
        message={toast.message}
        type={toast.type}
        visible={toast.visible}
        onHide={() => setToast({ ...toast, visible: false })}
      />
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: colors.background,
  },
  scrollView: {
    flex: 1,
  },
  content: {
    padding: wp('4%'),
  },
  statusCard: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: wp('4%'),
  },
  requestId: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    fontWeight: '600',
  },
  sectionTitle: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('3%'),
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: wp('2%'),
  },
  infoText: {
    fontSize: RFValue(14),
    color: colors.textPrimary,
    marginLeft: wp('2%'),
  },
  issueText: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    lineHeight: RFValue(20),
  },
  aiCard: {
    backgroundColor: `${colors.secondary}10`,
    borderWidth: 1,
    borderColor: colors.secondary,
  },
  aiHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: wp('2%'),
  },
  aiTitle: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.secondary,
    marginLeft: wp('2%'),
  },
  aiText: {
    fontSize: RFValue(13),
    color: colors.textPrimary,
    marginBottom: wp('1%'),
  },
  aiLabel: {
    fontWeight: '600',
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: wp('2%'),
  },
  detailLabel: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
  },
  detailValue: {
    fontSize: RFValue(13),
    color: colors.textPrimary,
    fontWeight: '600',
  },
  expertHeader: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  expertAvatar: {
    width: 50,
    height: 50,
    borderRadius: 25,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: wp('3%'),
  },
  expertAvatarText: {
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
  },
  expertRating: {
    fontSize: RFValue(12),
    color: colors.textSecondary,
    marginTop: wp('1%'),
  },
  callButton: {
    paddingHorizontal: wp('6%'),
  },
  actionButton: {
    marginTop: wp('2%'),
    marginBottom: wp('4%'),
  },
  errorContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  errorText: {
    fontSize: RFValue(16),
    color: colors.textSecondary,
  },
});

export default RequestDetailsScreen;
