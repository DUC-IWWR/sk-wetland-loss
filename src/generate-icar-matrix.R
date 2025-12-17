generate_icar_matrix <- function(shp = NULL)
{
  sf::sf_use_s2(FALSE)
  nb_list <- spdep::poly2nb(sf::st_as_sf(shp))
  icar_data <- mungeCARdata4stan(unlist(nb_list), lengths(nb_list))

  return(icar_data)
}