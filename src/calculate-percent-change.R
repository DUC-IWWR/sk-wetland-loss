calculate_percent_change <- function(shp) {
  return(
    sum(shp[which(shp$DClassPres %in% c("NewAgricultural", "NewSkeleton", "NewChannelized")), "LengthKM"]) / 
      (
        sum(shp[which(shp$DClassPres %in% c("EnhancedAgricultural", "EnhancedSkeleton", "EnhancedChannelized")), "LengthKM"]) +
          sum(shp[which(shp$DClassPres %in% c("Agricultural", "Skeleton", "Channelized")), "LengthKM"])
      )
  )
}