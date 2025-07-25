import React, { useState } from 'react';
import { View, StyleSheet, Alert, Image, Dimensions } from 'react-native';
import { TextInput, Button, Text } from 'react-native-paper';
import { useAuth } from '../../contexts/AuthContext';
import { useNavigation } from '@react-navigation/native';
import { LinearGradient } from 'expo-linear-gradient';

const SignUpScreen: React.FC = () => {
  const [username, setUsername] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const { signUp } = useAuth();
  const navigation = useNavigation();

  const handleSignUp = async () => {
    if (!username || !email || !password || !confirmPassword) {
      Alert.alert('Error', 'Please fill in all fields');
      return;
    }

    if (password !== confirmPassword) {
      Alert.alert('Error', 'Passwords do not match');
      return;
    }

    if (password.length < 6) {
      Alert.alert('Error', 'Password must be at least 6 characters long');
      return;
    }

    try {
      setIsLoading(true);
      await signUp(email, password, 'customer');
      Alert.alert('Success', 'Account created successfully! Please check your email for verification.');
    } catch (error: any) {
      Alert.alert('Sign Up Failed', error.message || 'An error occurred during sign up');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSignIn = () => {
    console.log('Sign In button pressed!');
    navigation.navigate('Login' as never);
  };

  return (
    <LinearGradient
      colors={['#ffffff', '#fafbfc', '#f5f7fa']}
      style={styles.container}
    >
      <View style={styles.content}>
        {/* Logo Section */}
        <View style={styles.logoSection}>
          <Image
            source={require('../../../assets/freshsave_logo.png')}
            style={styles.logo}
            resizeMode="contain"
          />
          <Text style={styles.tagline}>Fresh products, smart savings</Text>
        </View>

        {/* Form Section */}
        <View style={styles.formSection}>
          <Text style={styles.welcomeText}>Create Account</Text>
          <Text style={styles.subtitle}>Join FreshSave today</Text>
          
          <View style={styles.inputContainer}>
            <TextInput
              label="Username"
              value={username}
              onChangeText={setUsername}
              mode="outlined"
              style={styles.input}
              autoCapitalize="none"
              outlineColor="#e0e0e0"
              activeOutlineColor="#4CAF50"
              theme={{ colors: { primary: '#4CAF50' } }}
            />
            
            <TextInput
              label="Email"
              value={email}
              onChangeText={setEmail}
              mode="outlined"
              style={styles.input}
              keyboardType="email-address"
              autoCapitalize="none"
              outlineColor="#e0e0e0"
              activeOutlineColor="#4CAF50"
              theme={{ colors: { primary: '#4CAF50' } }}
            />
            
            <TextInput
              label="Password"
              value={password}
              onChangeText={setPassword}
              mode="outlined"
              style={styles.input}
              secureTextEntry
              outlineColor="#e0e0e0"
              activeOutlineColor="#4CAF50"
              theme={{ colors: { primary: '#4CAF50' } }}
            />
            
            <TextInput
              label="Confirm Password"
              value={confirmPassword}
              onChangeText={setConfirmPassword}
              mode="outlined"
              style={styles.input}
              secureTextEntry
              outlineColor="#e0e0e0"
              activeOutlineColor="#4CAF50"
              theme={{ colors: { primary: '#4CAF50' } }}
            />
          </View>
          
          <Button
            mode="contained"
            onPress={handleSignUp}
            loading={isLoading}
            disabled={isLoading}
            style={styles.signUpButton}
            contentStyle={styles.buttonContent}
            labelStyle={styles.buttonLabel}
          >
            Create Account
          </Button>
          
          <View style={styles.divider}>
            <View style={styles.dividerLine} />
            <Text style={styles.dividerText}>or</Text>
            <View style={styles.dividerLine} />
          </View>
          
          <View style={styles.signInContainer}>
            <Text style={styles.signInText}>
              Already have an account?{' '}
            </Text>
            <Text style={styles.signInLink} onPress={handleSignIn}>
              Sign In
            </Text>
          </View>
        </View>

        {/* Empty bottom 40% */}
        <View style={styles.emptySpace} />
      </View>
    </LinearGradient>
  );
};

const { width, height } = Dimensions.get('window');

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  content: {
    flex: 1,
    justifyContent: 'space-between',
    paddingHorizontal: 24,
    paddingTop: height * 0.1,
    paddingBottom: 40,
  },
  logoSection: {
    alignItems: 'center',
    marginBottom: 40,
  },
  logo: {
    width: width * 0.3,
    height: width * 0.3,
    marginBottom: 20,
  },
  tagline: {
    fontSize: 15,
    color: '#888',
    textAlign: 'center',
    fontStyle: 'italic',
    letterSpacing: 0.8,
    fontWeight: '300',
  },
  formSection: {
    flex: 1,
    justifyContent: 'center',
    maxWidth: 400,
    alignSelf: 'center',
    width: '100%',
  },
  welcomeText: {
    fontSize: 36,
    fontWeight: '800',
    color: '#1a1a1a',
    textAlign: 'center',
    marginBottom: 12,
    letterSpacing: -1,
  },
  subtitle: {
    fontSize: 17,
    color: '#777',
    textAlign: 'center',
    marginBottom: 48,
    letterSpacing: 0.3,
    fontWeight: '400',
  },
  inputContainer: {
    marginBottom: 32,
  },
  input: {
    marginBottom: 20,
    backgroundColor: 'white',
    borderRadius: 16,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
  },
  signUpButton: {
    backgroundColor: '#4CAF50',
    borderRadius: 16,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
  },
  buttonContent: {
    paddingVertical: 12,
  },
  buttonLabel: {
    fontSize: 17,
    fontWeight: '700',
    letterSpacing: 0.8,
  },
  divider: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 32,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: '#e8e8e8',
  },
  dividerText: {
    marginHorizontal: 20,
    color: '#aaa',
    fontSize: 15,
    fontWeight: '400',
  },
  signInContainer: {
    alignItems: 'center',
    marginTop: 0,
  },
  signInText: {
    fontSize: 15,
    color: '#666',
    textAlign: 'center',
    lineHeight: 22,
  },
  signInLink: {
    color: '#4CAF50',
    fontWeight: '600',
    textDecorationLine: 'underline',
  },
  emptySpace: {
    height: height * 0.4,
  },
});

export default SignUpScreen; 