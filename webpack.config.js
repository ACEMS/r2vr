const path = require('path');

module.exports = {
  context: __dirname,
  entry: {
    bundle2d: './typescript/2d/index.ts',
    training2d: './typescript/2dNew/training2d.ts',
    testing2d: './typescript/2dNew/testing2d.ts',
    training3d: './typescript/3d/training3d.ts',
    testing3d: './typescript/3d/testing3d.ts',
  },
  output: {
    path: path.resolve(__dirname, 'inst', 'js'),
    filename: '[name].js',
    publicPath: '/dist/js/',
  },
  module: {
    rules: [
      {
        test: /\.ts$/, // expression for all files ending in .ts
        exclude: /node_modules(?!\/rxjs)/,
        use: {
          loader: 'ts-loader',
        },
      },
    ],
  },
  resolve: {
    extensions: ['.ts', '.js'],
  },
};
