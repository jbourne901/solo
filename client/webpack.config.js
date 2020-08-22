const path = require("path");
const MiniCssExtractPlugin = require("mini-css-extract-plugin");
const HtmlWebpackPlugin = require("html-webpack-plugin");
const {CleanWebpackPlugin} = require("clean-webpack-plugin");
const TerserWebpackPlugin = require("terser-webpack-plugin");
const OptimizeCsAssetsWebpackPlugin = require("optimize-css-assets-webpack-plugin");
const Dotenv = require("dotenv-webpack");

const js_rule = {   test: /\.(ts|js)x?$/,
                    exclude: /node_modules/,
                    use: [
                           {
                             loader: 'babel-loader',
                             options: {
                                 presets: [
                                           "@babel/preset-env"
                                          ],
                                 plugins: [
                                           "@babel/plugin-proposal-class-properties"
                                 ]
                             }
                           },
                           {loader: 'ts-loader'}
                   ]
};

const css_rule = {  
 	            test: /\.css$/,
                    use: ['style-loader', 'css-loader'],
                    exclude: /node_modules/
};

const img_rule = { test:  /\.(png|jpg|gif|svg|ttf|woff2|eot)$/,
                   use: ["file-loader"]    
                 };

const mode = "production";

let devtool = undefined;
if(mode!=="production") {
   devtool = "inline-source-map";
}

module.exports = {
    entry: path.resolve(__dirname, "./src/index.tsx"),
    devtool,
    mode,
    devServer: { port: 4200 },
    output: {
        filename: "[name].[contenthash].js",
        path: path.resolve(__dirname, "dist")
    },
    module: { rules: [ js_rule, css_rule, img_rule ] },
    resolve: {
        extensions: [ '.tsx', '.ts', '.js' ],
    },
    plugins: [ new HtmlWebpackPlugin({template: path.resolve(__dirname, "./public/index.html"),
                                      minify: {collapseWhitespace: true}
                                     }),
               new CleanWebpackPlugin(),
               new MiniCssExtractPlugin({
                    filename: "[name].[contenthash].css"
               }),
               new Dotenv({
                   path: './.env',
                   safe: true
               })
             ],
   optimization: {
       splitChunks: {
           chunks: 'all',
       },
       minimizer: [
                    new OptimizeCsAssetsWebpackPlugin(),
                    new TerserWebpackPlugin()
                  ]
   }
};



