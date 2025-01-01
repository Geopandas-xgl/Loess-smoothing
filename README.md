# Loess smoothing

------

#### **Introduction**

This R program performs loess smoothing on isotope data and generates visualizations with confidence intervals. It is designed for geochronological or paleoclimatic studies where smoothing and plotting of isotopic data, such as Uranium, Barium, and Lithium isotopes, are required.

The program includes the following functionalities:

1. **Preprocess raw data** from an Excel file (e.g., sorting, grouping).
2. **Perform loess smoothing** with adjustable parameters.
3. **Generate and save horizontal figure** of the smoothed data and confidence intervals.
4. **Export results** to an Excel file for further analysis.

This program is beginner-friendly, with clear comments and explanations, making it easy to customize and apply to your dataset.

------

#### **Requirements**

To run this program, ensure the following are installed on your system:

- R language
- RStudio (optional but recommended)

The program uses the following R packages:

- `xlsx`: For reading and writing Excel files.
- `msir`: For loess smoothing with standard deviation.
- `ggplot2`: For creating high-quality plots.

If these packages are not installed, the program will install them automatically.

------

#### **How to Use**

1. **Prepare Your Data**

   - Create an Excel file with your data. Each sheet should represent a dataset. Ensure your sheet includes:
     - A column for the isotopic values.
     - A column for the corresponding time.
   - Place the Excel file in the working directory.

2. **Set Up Your Working Environment**

   - Modify the `setwd()` function to match your working directory. For example:

     ```r
     setwd("C:/Users/YourUsername/Documents/YourProjectFolder")
     ```

3. **Customize the Program**

   - Update the `section` variable to match the name of the sheet in your Excel file:

     ```r
     section <- "YourSheetName"
     ```

   - Update the column names:

     ```r
     colnames(data_raw)[colnames(data_raw) == "YourIsotopeColumnName"] <- "Delta"
     colnames(data_raw)[colnames(data_raw) == "YourTimeColumnName"] <- "Series"
     ```

   - Adjust loess smoothing parameters as needed:

     - `span`: Controls the degree of smoothing. Default is `0.7`.
     - `nsigma`: Sets the confidence interval range. Default is `2`.

4. **Run the Program**

   - Execute the script in R or RStudio. The program will:
     - Read the data from the specified Excel file and sheet.
     - Perform loess smoothing on the data.
     - Generate a plot with confidence intervals.
     - Automatically save the plot and smoothed data to a `section_name` subdirectory.

5. **Check the Outputs**

   - Create a new folder under the working directory:

     ```
     <section_name>
     ```

   - Smoothed data will be saved in an Excel file:

     ```
     <section_name>/<section_name>_<span>_loess.xlsx
     ```

   - Plots will be saved as PNG (bitmap) and PDF (vector graphic) files:

     ```
     <section_name>/<section_name>_<span>.png
     <section_name>/<section_name>_<span>.pdf
     ```

------

#### **Example Usage**

- Suppose you have an Excel file named `Zhang-2018-Loess.xlsx` with a sheet titled `PTB_dU` containing `age` and `dU` values.

- Update the script:

  ```r
  section <- "PTB_dU"
  setwd("C:/Users/19328/Documents/github/R-code/Loess/Template_horizontal")
  span <- 0.7  # Smoothing parameter
  nsigma <- 2  # Confidence interval width
  ```

- Run the script. The program will:

  - Perform loess smoothing on the data in `PTB_dU`.
  - Divide data into four groups based on profiles (Dawen, Dajiang, Kamura, Taskent).
  - Save results in the `PTB_dU` subdirectory.

- The test data is derived from ([Zhang et al., 2018, Geology](https://pubs.geoscienceworld.org/gsa/geology/article-abstract/46/4/327/527934/Congruent-Permian-Triassic-238U-records-at)).

------

#### **Key Features**

- **Customizable Parameters:** Easily adjust smoothing span and confidence intervals.
- **Automatic File Naming:** Output files are dynamically named based on the section and parameters.
- **Visualization:** High-quality horizontal figure that y-axis and x-axis correspond to isotopes and time, respectively.
- **Beginner-Friendly:** Clear comments and a modular structure for easy learning and adaptation.

------

#### **Troubleshooting**

1. **Excel File Issues**

   - Ensure the Excel file exists in the specified directory.
   - Verify the sheet name matches the `section` variable.
   - Check column names for the isotopic values and the corresponding time.

2. **Package Errors**

   - If a package fails to install automatically, install it manually:

     ```r
     install.packages("packageName")
     ```

3. **Output Directory**

   - Ensure you have write permissions for the working directory.

------

#### **Loess Smoothing Parameters**

- **`span`**: Refers to the fraction of the data used to fit each local polynomial in the smoothing process, ranging from 0 to 1. Larger values produce smoother curves.
- **`nsigma`**: Refers to the standard deviation of the residuals (RSD). For example, `n = 1` represents "1 RSD," and `n = 2` represents "2 RSD."

For more information, refer to [loess.sd documentation](https://www.rdocumentation.org/packages/msir/versions/1.3.3/topics/loess.sd).

------

#### **Saved Data File**

- **Y_loess:** Loess-smoothed isotope values.
- **X_loess:** Loess-smoothed time values.
- **upper:** Upper limit of the loess isotope, calculated as `X + nsigma`.
- **lower:** Lower limit of the loess isotope, calculated as `X - nsigma`.

------

#### **Acknowledgments**

This program is designed to simplify the process of smoothing and visualizing isotopic data for educational and research purposes. Feedback and contributions are welcome! Email: [xiongguolin@smail.nju.edu.cn](mailto:xiongguolin@smail.nju.edu.cn)

Update version Links: [Geopandas-xgl](https://github.com/Geopandas-xgl/Loess-smoothing) 
