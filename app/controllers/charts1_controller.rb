require("financechart")
require("chartdirector")

class Charts1Controller < ApplicationController
  include ChartDirector::InteractiveChartSupport
  def index
    #debugger
    @stock = params[:ticker_symbol] || "A"
    
    stock_details = Stock.find_by_stock_name(@stock).stocks_details
        @timeStamps = stock_details.collect(&:date)[-200..-1]
        @timeStamps.map! do |e| 
          e = e.to_time
          e =  ChartDirector::chartTime2(e.to_i) 
        end
        @highData = stock_details.collect(&:high)[-200..-1]
        @lowData = stock_details.collect(&:low)[-200..-1]
        @openData = stock_details.collect(&:open)[-200..-1]
        @closeData = stock_details.collect(&:close)[-200..-1]
        @volData = stock_details.collect(&:volume)[-200..-1]
        
        # Create a FinanceChart object of width 720 pixels
        c = ChartDirector::FinanceChart.new(720)

        # Add a title to the chart
        c.addTitle("Finance Chart Demonstration" + @stock)

        # Disable default legend box, as we are using dynamic legend
        c.setLegendStyle("normal", 8, ChartDirector::Transparent,
            ChartDirector::Transparent)

        # Set the data into the finance chart object
        c.setData(@timeStamps, @highData, @lowData, @openData, @closeData, @volData, 20)

        # Add the main chart with 240 pixels in height
        c.addMainChart(240)

        # Add a 10 period simple moving average to the main chart, using brown color
        c.addSimpleMovingAvg(10, 0x663300)

        # Add a 20 period simple moving average to the main chart, using purple color
        c.addSimpleMovingAvg(20, 0x9900ff)

        # Add candlestick symbols to the main chart, using green/red for up/down days
        c.addCandleStick(0x00ff00, 0xff0000)

        # Add 20 days bollinger band to the main chart, using light blue (9999ff) as the
        # border and semi-transparent blue (c06666ff) as the fill color
        c.addBollingerBand(20, 2, 0x9999ff, 0xc06666ff)

        # Add a 75 pixels volume bars sub-chart to the bottom of the main chart, using
        # green/red/grey for up/down/flat days
        c.addVolBars(75, 0x99ff99, 0xff9999, 0x808080)

        # Append a 14-days RSI indicator chart (75 pixels high) after the main chart. The
        # main RSI line is purple (800080). Set threshold region to +/- 20 (that is, RSI =
        # 50 +/- 25). The upper/lower threshold regions will be filled with red
        # (ff0000)/blue (0000ff).
        c.addRSI(75, 14, 0x800080, 20, 0xff0000, 0x0000ff)

        # Append a MACD(26, 12) indicator chart (75 pixels high) after the main chart,
        # using 9 days for computing divergence.
        c.addMACD(75, 26, 12, 9, 0x0000ff, 0xff00ff, 0x008000)
        
        # # Output the chart
        # send_data(c.makeChart2(ChartDirector::PNG), :type => "image/png",
            # :disposition => "inline")
        
        # Create the WebChartViewer object
        @viewer = ChartDirector::WebChartViewer.new(request, "chart11")
        #debugger
        # Create the image and save it in a session variable
        session[@viewer.getId()] = c.makeChart2(ChartDirector::PNG)

        # Set the chart URL to the viewer
        @viewer.setImageUrl(url_for(:action => "get_session_data", :id => @viewer.getId(),
            :nocache => rand))

        # Output Javascript chart model to the browser to support tracking cursor
        @viewer.setChartModel(c.getJsChartModel())
        
  end
end