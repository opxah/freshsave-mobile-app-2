import { Amplify } from 'aws-amplify';

console.log('Loading AWS config...');

const awsConfig = {
  Auth: {
    region: 'eu-central-1',
    userPoolId: 'eu-central-1_wtE34XYKv',
    userPoolWebClientId: '63bqi9lce9feb3del8g8or96c4',
  },
};

console.log('AWS config object:', awsConfig);

// Configure Amplify with error handling
try {
  console.log('Configuring Amplify...');
  Amplify.configure(awsConfig);
  console.log('AWS Amplify configured successfully');
} catch (error) {
  console.error('Error configuring AWS Amplify:', error);
}

export default awsConfig; 