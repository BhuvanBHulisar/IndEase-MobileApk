import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  ScrollView,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import RazorpayCheckout from 'react-native-razorpay';
import Card from '../../components/Card';
import Button from '../../components/Button';
import Header from '../../components/Header';
import Toast from '../../components/Toast';
import { createOrder, verifyPayment } from '../../services/paymentService';
import { useAuth } from '../../context/AuthContext';
import colors from '../../constants/colors';
import { formatCurrency } from '../../utils/formatters';

const PaymentScreen = ({ navigation, route }) => {
  const { requestId, quoteId, amount } = route.params;
  const { user } = useAuth();
  const [loading, setLoading] = useState(false);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  const handlePayment = async () => {
    try {
      setLoading(true);

      // Create order
      const orderData = await createOrder(amount, requestId);

      // Open Razorpay
      const options = {
        description: 'Service Payment',
        image: 'https://your-logo-url.com/logo.png',
        currency: orderData.currency || 'INR',
        key: orderData.key,
        amount: orderData.amount,
        order_id: orderData.orderId,
        name: 'IndEase',
        prefill: {
          email: user.email,
          contact: user.phone || '',
          name: `${user.firstName} ${user.lastName}`,
        },
        theme: { color: colors.primary },
      };

      RazorpayCheckout.open(options)
        .then(async (data) => {
          // Payment successful
          try {
            await verifyPayment({
              razorpay_order_id: data.razorpay_order_id,
              razorpay_payment_id: data.razorpay_payment_id,
              razorpay_signature: data.razorpay_signature,
              requestId,
            });

            setToast({
              visible: true,
              message: 'Payment successful! Expert has been notified.',
              type: 'success',
            });

            setTimeout(() => {
              navigation.navigate('RequestDetails', { requestId });
            }, 2000);
          } catch (error) {
            setToast({
              visible: true,
              message: 'Payment verification failed',
              type: 'error',
            });
          }
        })
        .catch((error) => {
          setToast({
            visible: true,
            message: 'Payment cancelled or failed',
            type: 'error',
          });
        })
        .finally(() => {
          setLoading(false);
        });
    } catch (error) {
      setLoading(false);
      setToast({
        visible: true,
        message: error.response?.data?.message || 'Failed to initiate payment',
        type: 'error',
      });
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <Header title="Payment" onBack={() => navigation.goBack()} />

      <ScrollView style={styles.scrollView} contentContainerStyle={styles.content}>
        <Card style={styles.amountCard}>
          <Text style={styles.amountLabel}>Total Amount</Text>
          <Text style={styles.amountValue}>{formatCurrency(amount)}</Text>
        </Card>

        <Card>
          <Text style={styles.sectionTitle}>Payment Details</Text>
          <View style={styles.detailRow}>
            <Text style={styles.detailLabel}>Service Charge</Text>
            <Text style={styles.detailValue}>{formatCurrency(amount)}</Text>
          </View>
          <View style={styles.detailRow}>
            <Text style={styles.detailLabel}>Payment Method</Text>
            <Text style={styles.detailValue}>Razorpay</Text>
          </View>
        </Card>

        <Card style={styles.infoCard}>
          <Text style={styles.infoTitle}>💡 Payment Information</Text>
          <Text style={styles.infoText}>
            • Your payment will be held in escrow{'\n'}
            • Payment is released to expert after you confirm completion{'\n'}
            • Secure payment via Razorpay{'\n'}
            • All major payment methods accepted
          </Text>
        </Card>

        <Button
          title={`Pay ${formatCurrency(amount)} with Razorpay`}
          onPress={handlePayment}
          loading={loading}
          style={styles.payButton}
        />
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
  amountCard: {
    alignItems: 'center',
    paddingVertical: wp('8%'),
    marginBottom: wp('4%'),
  },
  amountLabel: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
    marginBottom: wp('2%'),
  },
  amountValue: {
    fontSize: RFValue(36),
    fontWeight: '700',
    color: colors.primary,
  },
  sectionTitle: {
    fontSize: RFValue(16),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('3%'),
  },
  detailRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: wp('2%'),
  },
  detailLabel: {
    fontSize: RFValue(14),
    color: colors.textSecondary,
  },
  detailValue: {
    fontSize: RFValue(14),
    color: colors.textPrimary,
    fontWeight: '600',
  },
  infoCard: {
    backgroundColor: `${colors.secondary}10`,
    borderWidth: 1,
    borderColor: colors.secondary,
  },
  infoTitle: {
    fontSize: RFValue(15),
    fontWeight: '700',
    color: colors.textPrimary,
    marginBottom: wp('2%'),
  },
  infoText: {
    fontSize: RFValue(13),
    color: colors.textSecondary,
    lineHeight: RFValue(20),
  },
  payButton: {
    marginTop: wp('4%'),
  },
});

export default PaymentScreen;
