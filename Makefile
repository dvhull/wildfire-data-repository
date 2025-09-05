# -------- Paths --------
BASE_DIR := wildfire-datasets/raw-data/nfdb

# Subfolders to extract into
POINT_DIR := $(BASE_DIR)/NFDB_point
LARGE_DIR := $(BASE_DIR)/NFDB_point_large_fires

# Zip paths (kept inside each dataset folder)
POINT_ZIP := $(POINT_DIR)/NFDB_point.zip
LARGE_ZIP := $(LARGE_DIR)/NFDB_point_large_fires.zip

# -------- Sources --------
POINT_URL := https://cwfis.cfs.nrcan.gc.ca/downloads/nfdb/fire_pnt/current_version/NFDB_point.zip
LARGE_URL := https://cwfis.cfs.nrcan.gc.ca/downloads/nfdb/fire_pnt/current_version/NFDB_point_large_fires.zip

.PHONY: all nfdb point large_fires clean \
        fwi-on fwi-batch fwi-archive \
        nbac-30m nbac-30m-clean \
        fbp-fueltypes fbp-fueltypes-clean

# Default: get both NFDB datasets
all: nfdb

# Meta target for both datasets
nfdb: point large_fires

# ----- NFDB Point -----
point: $(POINT_DIR)
	curl -L -o $(POINT_ZIP) $(POINT_URL)  # Download NFDB_point
	unzip -o $(POINT_ZIP) -d $(POINT_DIR) # Extract into NFDB_point/

# ----- NFDB Point (Large Fires) -----
large_fires: $(LARGE_DIR)
	curl -L -o $(LARGE_ZIP) $(LARGE_URL)  # Download NFDB_point_large_fires
	unzip -o $(LARGE_ZIP) -d $(LARGE_DIR) # Extract into NFDB_point_large_fires/

# Create directories if missing
$(POINT_DIR):
	mkdir -p $(POINT_DIR)

$(LARGE_DIR):
	mkdir -p $(LARGE_DIR)

# Optional: remove only the downloaded zips (keeps extracted files)
clean:
	rm -f $(POINT_ZIP) $(LARGE_ZIP)

# -------- FWI SCRIBE Daily Grids (LIVE) --------
FWI_DIR  := wildfire-datasets/raw-data/fwi
FWI_BASE := https://cwfis.cfs.nrcan.gc.ca/downloads/cffdrs

# Date-stamped file for LIVE endpoint, e.g. 20250906 (only recent days exist)
DATE ?= 20250906
FWI_FILE := fwi_scribe_$(DATE).tif
FWI_PATH := $(FWI_DIR)/$(FWI_FILE)

# Download one daily file from the live directory (may 404 for older dates)
fwi-on: $(FWI_DIR)
	@echo "Fetching $(FWI_FILE) from LIVE endpoint ..."
	curl -fL -o $(FWI_PATH) $(FWI_BASE)/$(FWI_FILE)
	@echo "Saved to $(FWI_PATH)"

# Download a batch of specific days from LIVE endpoint
DATES = 20250904 20250905 20250906
fwi-batch: $(FWI_DIR)
	@for d in $(DATES); do \
	  f="fwi_scribe_$${d}.tif"; \
	  echo "Fetching $$f ..."; \
	  curl -fL -o $(FWI_DIR)/$$f $(FWI_BASE)/$$f || { echo "Skipped $$f (likely expired)"; }; \
	done
	@echo "Batch attempt complete."

# Ensure the fwi folder exists
$(FWI_DIR):
	mkdir -p $(FWI_DIR)

# -------- FWI Archive via WCS (REPRODUCIBLE) --------
BASE_WCS := https://cwfis.cfs.nrcan.gc.ca/geoserver/public/wcs?service=WCS&version=1.0.0&request=GetCoverage
FWI_ARCHIVE_FILE := fwi_$(DATE).tif
BBOX   := -2378164,-707617,3039835,3854382
WIDTH  := 2709
HEIGHT := 2281
CRS    := EPSG:3978
FORMAT := geotiff

fwi-archive: $(FWI_DIR)
	@echo "Fetching archived FWI for $(DATE) via WCS ..."
	curl -fL -o $(FWI_DIR)/$(FWI_ARCHIVE_FILE) \
	"$(BASE_WCS)&coverage=public:fwi$(DATE)&BBOX=$(BBOX)&WIDTH=$(WIDTH)&HEIGHT=$(HEIGHT)&CRS=$(CRS)&FORMAT=$(FORMAT)"
	@echo "Saved to $(FWI_DIR)/$(FWI_ARCHIVE_FILE)"

# -------- NBAC 30m (1972–2024) --------
NBAC_BASE_DIR := wildfire-datasets/raw-data/nbac
NBAC_30M_DIR  := $(NBAC_BASE_DIR)/NBAC_MRB_1972to2024_30m
NBAC_30M_ZIP  := $(NBAC_30M_DIR)/NBAC_MRB_1972to2024_30m.tif.zip
NBAC_30M_URL  := https://cwfis.cfs.nrcan.gc.ca/downloads/nbac/NBAC_MRB_1972to2024_30m.tif.zip

nbac-30m: $(NBAC_30M_DIR)
	curl -fL -o $(NBAC_30M_ZIP) $(NBAC_30M_URL)
	unzip -o $(NBAC_30M_ZIP) -d $(NBAC_30M_DIR)
	@echo "NBAC 30m ready in $(NBAC_30M_DIR)"

nbac-30m-clean:
	rm -f $(NBAC_30M_ZIP)

$(NBAC_30M_DIR):
	mkdir -p $(NBAC_30M_DIR)

# -------- FBP Fuel Types (100m EPSG:3978, 20240527) --------
FBP_BASE_DIR := wildfire-datasets/raw-data/fuel
FBP_DIR      := $(FBP_BASE_DIR)/FBP_fueltypes_100m
FBP_FILE     := $(FBP_DIR)/FBP_fueltypes_Canada_100m_EPSG3978_20240527.tif
FBP_URL      := https://cwfis.cfs.nrcan.gc.ca/downloads/fuels/current/FBP_fueltypes_Canada_100m_EPSG3978_20240527.tif

fbp-fueltypes: $(FBP_DIR)
	curl -fL -o $(FBP_FILE) $(FBP_URL)
	@echo "FBP fuel types raster ready in $(FBP_DIR)"

fbp-fueltypes-clean:
	rm -f $(FBP_FILE)

$(FBP_DIR):
	mkdir -p $(FBP_DIR)
