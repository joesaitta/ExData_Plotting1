# Download the zipped dataset if it doesn't already exist
if (!file.exists("./household_power_consumption.txt")) {
  url = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "hpc.zip", method = "curl")
  
  # Extract it
  unzip("hpc.zip")
}

# Try to read it in
print("We've got the data, let's read it in and clean in...")
data <- read.table("household_power_consumption.txt", header = TRUE, sep = ";", 
                   na.strings = "?", nrows = 69600, stringsAsFactors = FALSE)

# Clean up the date and time formats
data$Date <- as.Date(data$Date, format = "%d/%m/%Y")
data$Time <- strftime(strptime(data$Time, format="%T"), "%T")
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), format="%Y-%m-%d %H:%M:%S")

# Trim to the rows we need
data <- data[data$Date >= "2007-02-01" & data$Date <= "2007-02-02",]

# Plot 4, Multi-Plot
png(filename = "plot4.png", width = 480, height = 480)
par(mfrow = c(2, 2))
with(data, {
  
# 1st Plot
  plot(data$DateTime, data$Global_active_power, type = "l", 
       ylab = "Global Active Power", xlab = "")
  
# 2nd Plot
  plot(data$DateTime, data$Voltage, type = "l", 
       ylab = "Volatge", xlab = "datetime")

# 3rd Plot
  with(data, {
    plot(DateTime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = "")
    with(subset(data), points(DateTime, Sub_metering_2, type = "l", col = "red"))
    with(subset(data), points(DateTime, Sub_metering_3, type = "l", col = "blue"))
    legend("topright", lwd=1, col = c("black","red","blue"), 
          legend = c("Sub_metering_1", "Sub_metering_2","Sub_metering_3"),
          bty = "n", cex = 0.8, xjust = 1)
    })
# 4th Plot
  plot(data$DateTime, data$Global_reactive_power, type = "l", 
       ylab = "Global_reactive_power", xlab = "datetime")
})

dev.off()

print("plot 4 saved")