# Wildfire Data Repository 

This repository provides a **Makefile-based workflow** to fetch and organize core Canadian wildfire datasets. 

It ensures that large binary data files are not tracked in Git while keeping a reproducible folder structure for research and analysis.

## 🛠️ Requirements 

On Linux and macOS, make is typically installed by default.

**On Windows, make is not included.**

Recommended: Install WSL (Windows Subsystem for Linux) and run the commands in a Linux environment.

## 📂 Repository Structure

```text
wildfire-datasets/
  raw-data/
    nfdb/   # National Fire Database (points, large fires)
    fwi/    # Daily Fire Weather Index rasters (CFFDRS)
    nbac/   # National Burned Area Composite
    fuel/   # FBP fuel type grids
Makefile
README.md
```

## 📊 Datasets & Makefile Targets

### 🔹 NFDB (National Fire Database)
- `make nfdb` → Downloads both NFDB datasets.  
- `make point` → Downloads **NFDB_point.zip** and extracts shapefiles.  
- `make large_fires` → Downloads **NFDB_point_large_fires.zip** and extracts shapefiles.  

### 🔹 FWI (Fire Weather Index Grids)
- `make fwi-archive DATE=YYYYMMDD` → Fetches frozen archived GeoTIFFs from the **CWFIS WCS API**.  
- `make fwi-on DATE=YYYYMMDD` → Fetches a recent daily FWI grid (only available for recent LIVE days on website).  
- `make fwi-batch` → Downloads multiple specified daily grids. (only available for recent LIVE days on website, specified within makefile). 

### 🔹 NBAC (National Burned Area Composite, 30m, 1972–2024)
- `make nbac-30m` → Downloads the **national mosaic (ZIP)** and extracts it.  
- `make nbac-30m-clean` → Removes only the downloaded ZIP (keeps extracted data).  

### 🔹 FBP Fuel Types (100m EPSG:3978, 20240527)
- `make fbp-fueltypes` → Downloads the **FBP fuel types raster**.  
- `make fbp-fueltypes-clean` → Removes the raster file.  

---

## ⚡ Usage Examples

```bash
# Download NFDB datasets
make nfdb

# Fetch NFDB points only
make point

# Download today’s FWI grid (if available)
make fwi-on DATE=20250906

# Fetch archived FWI grid for June 4, 2023
make fwi-archive DATE=20230604

# Download and extract NBAC 30m mosaic
make nbac-30m

# Download the FBP fuel type raster
make fbp-fueltypes
```
