CREATE TRIGGER update_exoplanets
AFTER UPDATE ON exoplanet_stage.exoplanets
EXECUTE FUNCTION exoplanet_stage.update_exoplanets_data();