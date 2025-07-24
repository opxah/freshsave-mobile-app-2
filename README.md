# FreshSave Mobile App

A React Native mobile application for product management and barcode scanning, built with AWS integration.

## Features

### Customer Features
- **Barcode Scanning**: Scan product barcodes using the device camera
- **Manual Barcode Entry**: Enter barcode numbers manually
- **Product Lookup**: Search and view product details
- **Favorites Management**: Save and manage favorite products
- **Product Search**: Search products by name, brand, or category
- **Category Browsing**: Browse products by category

### Store Admin Features
- **Product Management**: Add, edit, and delete products
- **Image Upload**: Upload product images to AWS S3
- **Store Dashboard**: View store statistics and manage products
- **Store Profile**: Manage store information and contact details
- **Role-based Access**: Secure access control for store admins

## Tech Stack

- **Frontend**: React Native with Expo
- **UI Framework**: React Native Paper
- **Navigation**: React Navigation
- **Authentication**: AWS Cognito
- **Backend**: AWS API Gateway + Lambda
- **Database**: AWS DynamoDB
- **Storage**: AWS S3
- **Language**: TypeScript

## Prerequisites

- Node.js (v16 or higher)
- npm or yarn
- Expo CLI
- AWS Account with appropriate services configured

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd FreshSave
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Configure AWS Services**

   Update the AWS configuration in `src/services/aws-config.ts`:
   ```typescript
   const awsConfig = {
     Auth: {
       region: 'us-east-1', // Your AWS region
       userPoolId: 'YOUR_USER_POOL_ID',
       userPoolWebClientId: 'YOUR_USER_POOL_CLIENT_ID',
     },
     API: {
       endpoints: [
         {
           name: 'FreshSaveAPI',
           endpoint: 'YOUR_API_GATEWAY_URL',
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

4. **Set up AWS Services**

   ### AWS Cognito User Pool
   - Create a User Pool with email verification
   - Add custom attributes: `role` (String), `storeName` (String), `storeId` (String)
   - Create an App Client
   - Update the configuration with your User Pool ID and Client ID

   ### AWS DynamoDB Tables
   Create the following tables:

   **Products Table**
   ```json
   {
     "TableName": "FreshSave-Products",
     "KeySchema": [
       {"AttributeName": "barcode", "KeyType": "HASH"}
     ],
     "AttributeDefinitions": [
       {"AttributeName": "barcode", "AttributeType": "S"},
       {"AttributeName": "storeId", "AttributeType": "S"}
     ],
     "GlobalSecondaryIndexes": [
       {
         "IndexName": "StoreIdIndex",
         "KeySchema": [
           {"AttributeName": "storeId", "KeyType": "HASH"}
         ],
         "Projection": {"ProjectionType": "ALL"}
       }
     ]
   }
   ```

   **Stores Table**
   ```json
   {
     "TableName": "FreshSave-Stores",
     "KeySchema": [
       {"AttributeName": "id", "KeyType": "HASH"}
     ],
     "AttributeDefinitions": [
       {"AttributeName": "id", "AttributeType": "S"},
       {"AttributeName": "adminId", "AttributeType": "S"}
     ],
     "GlobalSecondaryIndexes": [
       {
         "IndexName": "AdminIdIndex",
         "KeySchema": [
           {"AttributeName": "adminId", "KeyType": "HASH"}
         ],
         "Projection": {"ProjectionType": "ALL"}
       }
     ]
   }
   ```

   **Favorites Table**
   ```json
   {
     "TableName": "FreshSave-Favorites",
     "KeySchema": [
       {"AttributeName": "userId", "KeyType": "HASH"},
       {"AttributeName": "productBarcode", "KeyType": "RANGE"}
     ],
     "AttributeDefinitions": [
       {"AttributeName": "userId", "AttributeType": "S"},
       {"AttributeName": "productBarcode", "AttributeType": "S"}
     ]
   }
   ```

   ### AWS S3 Bucket
   - Create a bucket named `freshsave-product-images`
   - Configure CORS for image uploads
   - Set up appropriate IAM policies

   ### AWS API Gateway
   - Create REST API endpoints for the following operations:
     - POST /products (create product)
     - GET /products/{barcode} (get product by barcode)
     - PUT /products/{barcode} (update product)
     - DELETE /products/{barcode} (delete product)
     - GET /stores/{storeId}/products (get store products)
     - GET /products/search (search products)
     - GET /products/category/{category} (get products by category)
     - POST /stores (create store)
     - GET /stores/{storeId} (get store)
     - PUT /stores/{storeId} (update store)
     - GET /stores/{storeId}/stats (get store stats)
     - POST /favorites (add to favorites)
     - DELETE /favorites/{userId}/{productBarcode} (remove from favorites)
     - GET /favorites/{userId} (get user favorites)
     - GET /favorites/{userId}/{productBarcode} (check favorite status)

5. **Run the application**
   ```bash
   # For iOS
   npm run ios
   
   # For Android
   npm run android
   
   # For web
   npm run web
   ```

## Project Structure

```
src/
├── components/          # Reusable UI components
├── contexts/           # React contexts (AuthContext)
├── navigation/         # Navigation configuration
├── screens/           # Screen components
│   ├── auth/          # Authentication screens
│   ├── customer/      # Customer-facing screens
│   └── admin/         # Store admin screens
├── services/          # API and AWS services
├── types/             # TypeScript type definitions
└── utils/             # Utility functions
```

## Usage

### For Customers
1. Sign up or log in as a customer
2. Use the barcode scanner or enter barcode manually
3. View product details and save to favorites
4. Search products by name, brand, or category
5. Manage your favorite products

### For Store Admins
1. Sign up as a store admin with store information
2. Access the admin dashboard
3. Add, edit, and delete products
4. Upload product images
5. Manage store profile and contact information

## Security Features

- Role-based access control (customer vs store_admin)
- Store isolation (admins can only manage their own store's products)
- AWS Cognito authentication
- Secure API endpoints with proper authorization

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

For support and questions, please contact the development team or create an issue in the repository. 