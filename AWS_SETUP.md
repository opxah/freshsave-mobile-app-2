# AWS Infrastructure Setup Guide

This guide will help you set up the AWS infrastructure required for the FreshSave mobile app.

## Prerequisites

- AWS Account with appropriate permissions
- AWS CLI configured (optional but recommended)
- Basic understanding of AWS services

## 1. AWS Cognito User Pool Setup

### Create User Pool
1. Go to AWS Cognito Console
2. Click "Create user pool"
3. Configure sign-in experience:
   - Choose "Cognito user pool"
   - Pool name: `FreshSave-UserPool`
   - Choose "Email" for sign-in options

### Configure Security Requirements
1. Password policy: Minimum 6 characters
2. Multi-factor authentication: Optional
3. User account recovery: Email

### Configure App Integration
1. App client name: `FreshSave-Client`
2. Client secret: Generate client secret
3. Authentication flows: ALLOW_USER_PASSWORD_AUTH, ALLOW_REFRESH_TOKEN_AUTH

### Add Custom Attributes
Add the following custom attributes:
- `role` (String) - Required
- `storeName` (String) - Optional
- `storeId` (String) - Optional

### Note Down Credentials
- User Pool ID
- App Client ID
- App Client Secret

## 2. DynamoDB Tables Setup

### Products Table
```bash
aws dynamodb create-table \
  --table-name FreshSave-Products \
  --attribute-definitions \
    AttributeName=barcode,AttributeType=S \
    AttributeName=storeId,AttributeType=S \
  --key-schema AttributeName=barcode,KeyType=HASH \
  --global-secondary-indexes \
    IndexName=StoreIdIndex,KeySchema=[{AttributeName=storeId,KeyType=HASH}],Projection={ProjectionType=ALL} \
  --billing-mode PAY_PER_REQUEST
```

### Stores Table
```bash
aws dynamodb create-table \
  --table-name FreshSave-Stores \
  --attribute-definitions \
    AttributeName=id,AttributeType=S \
    AttributeName=adminId,AttributeType=S \
  --key-schema AttributeName=id,KeyType=HASH \
  --global-secondary-indexes \
    IndexName=AdminIdIndex,KeySchema=[{AttributeName=adminId,KeyType=HASH}],Projection={ProjectionType=ALL} \
  --billing-mode PAY_PER_REQUEST
```

### Favorites Table
```bash
aws dynamodb create-table \
  --table-name FreshSave-Favorites \
  --attribute-definitions \
    AttributeName=userId,AttributeType=S \
    AttributeName=productBarcode,AttributeType=S \
  --key-schema AttributeName=userId,KeyType=HASH AttributeName=productBarcode,KeyType=RANGE \
  --billing-mode PAY_PER_REQUEST
```

## 3. S3 Bucket Setup

### Create Bucket
```bash
aws s3 mb s3://freshsave-product-images
```

### Configure CORS
Create a file named `cors.json`:
```json
[
  {
    "AllowedHeaders": ["*"],
    "AllowedMethods": ["GET", "PUT", "POST", "DELETE"],
    "AllowedOrigins": ["*"],
    "ExposeHeaders": []
  }
]
```

Apply CORS configuration:
```bash
aws s3api put-bucket-cors --bucket freshsave-product-images --cors-configuration file://cors.json
```

### Create IAM Policy for S3 Access
Create a policy file `s3-policy.json`:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::freshsave-product-images/*"
    }
  ]
}
```

## 4. API Gateway Setup

### Create REST API
1. Go to API Gateway Console
2. Click "Create API"
3. Choose "REST API"
4. API name: `FreshSave-API`
5. Endpoint type: Regional

### Create Resources and Methods

#### Products Resource
- `POST /products` - Create product
- `GET /products/{barcode}` - Get product by barcode
- `PUT /products/{barcode}` - Update product
- `DELETE /products/{barcode}` - Delete product
- `GET /products/search` - Search products
- `GET /products/category/{category}` - Get products by category

#### Stores Resource
- `POST /stores` - Create store
- `GET /stores/{storeId}` - Get store
- `PUT /stores/{storeId}` - Update store
- `GET /stores/{storeId}/products` - Get store products
- `GET /stores/{storeId}/stats` - Get store stats

#### Favorites Resource
- `POST /favorites` - Add to favorites
- `DELETE /favorites/{userId}/{productBarcode}` - Remove from favorites
- `GET /favorites/{userId}` - Get user favorites
- `GET /favorites/{userId}/{productBarcode}` - Check favorite status

### Lambda Functions
Create Lambda functions for each API endpoint. Example for getting a product:

```javascript
// getProduct.js
const AWS = require('aws-sdk');
const dynamodb = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event) => {
  const { barcode } = event.pathParameters;
  
  try {
    const params = {
      TableName: 'FreshSave-Products',
      Key: { barcode }
    };
    
    const result = await dynamodb.get(params).promise();
    
    return {
      statusCode: 200,
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET'
      },
      body: JSON.stringify(result.Item || null)
    };
  } catch (error) {
    return {
      statusCode: 500,
      headers: {
        'Access-Control-Allow-Origin': '*'
      },
      body: JSON.stringify({ error: error.message })
    };
  }
};
```

### Deploy API
1. Create a deployment stage (e.g., "prod")
2. Note the invoke URL

## 5. IAM Roles and Policies

### Cognito Identity Pool (Optional)
If you want to use AWS credentials directly from Cognito:

1. Create Identity Pool
2. Configure roles for authenticated and unauthenticated users
3. Attach appropriate policies for DynamoDB and S3 access

### Lambda Execution Role
Create IAM role with policies for:
- DynamoDB access
- S3 access
- CloudWatch Logs

## 6. Environment Variables

Update your app configuration with the following values:

```typescript
// src/services/aws-config.ts
const awsConfig = {
  Auth: {
    region: 'us-east-1', // Your region
    userPoolId: 'us-east-1_XXXXXXXXX', // Your User Pool ID
    userPoolWebClientId: 'XXXXXXXXXXXXXXXXXXXXXXXXXX', // Your App Client ID
  },
  API: {
    endpoints: [
      {
        name: 'FreshSaveAPI',
        endpoint: 'https://XXXXXXXXXX.execute-api.us-east-1.amazonaws.com/prod', // Your API Gateway URL
        region: 'us-east-1',
      },
    ],
  },
  Storage: {
    AWSS3: {
      bucket: 'freshsave-product-images',
      region: 'us-east-1',
    },
  },
};
```

## 7. Testing the Setup

### Test Cognito Authentication
1. Create a test user in the User Pool
2. Test sign-up and sign-in flows
3. Verify custom attributes are set correctly

### Test DynamoDB Operations
1. Insert test data into tables
2. Test queries and scans
3. Verify GSI functionality

### Test S3 Operations
1. Upload test images
2. Verify CORS configuration
3. Test image retrieval

### Test API Gateway
1. Test all endpoints with Postman or similar tool
2. Verify CORS headers
3. Test error handling

## 8. Security Considerations

### API Gateway Security
- Enable API key authentication if needed
- Configure rate limiting
- Set up proper CORS policies

### DynamoDB Security
- Use IAM policies to restrict access
- Enable encryption at rest
- Consider using VPC endpoints

### S3 Security
- Enable bucket encryption
- Configure bucket policies
- Set up access logging

## 9. Monitoring and Logging

### CloudWatch
- Set up CloudWatch Logs for Lambda functions
- Create dashboards for monitoring
- Set up alarms for errors

### X-Ray (Optional)
- Enable X-Ray tracing for better debugging
- Monitor API performance

## 10. Cost Optimization

### DynamoDB
- Use on-demand billing for development
- Consider provisioned capacity for production
- Monitor read/write capacity units

### Lambda
- Monitor function execution time
- Optimize cold start times
- Use appropriate memory allocation

### S3
- Set up lifecycle policies for old images
- Monitor storage usage
- Consider using S3 Intelligent Tiering

## Troubleshooting

### Common Issues
1. **CORS errors**: Check API Gateway CORS configuration
2. **Authentication errors**: Verify Cognito configuration
3. **Permission errors**: Check IAM policies
4. **DynamoDB errors**: Verify table structure and indexes

### Debugging Tips
1. Check CloudWatch Logs for Lambda functions
2. Use AWS CLI to test services directly
3. Verify all environment variables are set correctly
4. Test with Postman before integrating with the app

## Next Steps

1. Set up CI/CD pipeline
2. Implement backup strategies
3. Set up monitoring and alerting
4. Plan for scaling
5. Implement security best practices 