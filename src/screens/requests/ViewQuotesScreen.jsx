import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  SafeAreaView,
  FlatList,
} from 'react-native';
import { widthPercentageToDP as wp } from 'react-native-responsive-screen';
import { RFValue } from 'react-native-responsive-fontsize';
import QuoteCard from '../../components/QuoteCard';
import Header from '../../components/Header';
import LoadingSpinner from '../../components/LoadingSpinner';
import EmptyState from '../../components/EmptyState';
import Toast from '../../components/Toast';
import { getQuotes, approveQuote } from '../../services/requestService';
import colors from '../../constants/colors';

const ViewQuotesScreen = ({ navigation, route }) => {
  const { requestId } = route.params;
  const [quotes, setQuotes] = useState([]);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState({ visible: false, message: '', type: 'info' });

  useEffect(() => {
    loadQuotes();
  }, [requestId]);

  const loadQuotes = async () => {
    try {
      setLoading(true);
      const data = await getQuotes(requestId);
      setQuotes(data);
    } catch (error) {
      setToast({
        visible: true,
        message: 'Failed to load quotes',
        type: 'error',
      });
    } finally {
      setLoading(false);
    }
  };

  const handleApprove = async (quote) => {
    try {
      await approveQuote(requestId, quote._id || quote.id);
      setToast({
        visible: true,
        message: 'Quote approved! Proceeding to payment...',
        type: 'success',
      });

      setTimeout(() => {
        navigation.navigate('Payment', {
          requestId,
          quoteId: quote._id || quote.id,
          amount: quote.amount || (quote.labour_cost + quote.parts_cost),
        });
      }, 1000);
    } catch (error) {
      setToast({
        visible: true,
        message: error.response?.data?.message || 'Failed to approve quote',
        type: 'error',
      });
    }
  };

  const handleAskQuestion = (quote) => {
    // Navigate to chat with expert
    navigation.navigate('Chat', {
      requestId,
      expertId: quote.expert?._id || quote.producer?._id,
    });
  };

  if (loading) {
    return <LoadingSpinner />;
  }

  return (
    <SafeAreaView style={styles.container}>
      <Header
        title={`Expert Quotes (${quotes.length}/2)`}
        onBack={() => navigation.goBack()}
      />

      {quotes.length === 0 ? (
        <EmptyState
          icon="document-text-outline"
          title="No Quotes Yet"
          message="Experts are reviewing your request. You'll be notified when quotes arrive."
        />
      ) : (
        <FlatList
          data={quotes}
          keyExtractor={(item) => item._id || item.id}
          renderItem={({ item }) => (
            <QuoteCard
              quote={item}
              onApprove={handleApprove}
              onAskQuestion={handleAskQuestion}
            />
          )}
          contentContainerStyle={styles.list}
        />
      )}

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
  list: {
    padding: wp('4%'),
  },
});

export default ViewQuotesScreen;
