function name = CH_save_plot
  name = strcat("plot_", strftime ("%y%m%d_%H%M%S", localtime (time ())), ".png")
  print('dpng', name)
  disp "saved ..."
end

