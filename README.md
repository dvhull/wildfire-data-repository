# Wildfire Data Repository 

This repository provides a **Makefile-based workflow** to fetch and organize core Canadian wildfire datasets. 

It ensures that large binary data files are not tracked in Git while keeping a reproducible folder structure for research and analysis.

> ⚠️ Note: Large binary files (e.g., `.zip`, `.tif`, `.nc`, `.grib2`) are ignored via `.gitignore` in this repository. Datasets will need to be downloaded using the make commands down below once the repository has been cloned.   

## Requirements 

On Linux and macOS, `make` is typically installed by default.

**On Windows, `make` is not included.**

Recommended: Install Windows Subsystem for Linux (WSL) to run the repository in a Linux environment without leaving Windows.

Once inside your WSL terminal, install the required build tools:

```bash
sudo apt update
sudo apt install build-essential -y
```

This will install make along with other standard development utilities.

## Repository Structure

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
> ⚠️ Note: Large binary files (e.g., `.zip`, `.tif`, `.nc`, `.grib2`) are ignored via `.gitignore`.  
> Only scripts, metadata, and lightweight text files should be committed to Git.  

## 📊 Datasets & Makefile Targets

### Master Target
- `make all DATE=YYYYMMDD` → Fetches **all datasets** (NFDB, FWI archive, NBAC, FBP fuel types) in one command.  
  - `DATE` specifies the Fire Weather Index archive date. Defaults to the current placeholder in the Makefile. 

### NFDB (National Fire Database)
- `make nfdb` → Downloads both NFDB datasets.  
- `make point` → Downloads **NFDB_point.zip** and extracts shapefiles.  
- `make large_fires` → Downloads **NFDB_point_large_fires.zip** and extracts shapefiles.  

### FWI (Fire Weather Index Grids)
- `make fwi-archive DATE=YYYYMMDD` → Fetches frozen archived GeoTIFFs from the **CWFIS WCS API**.  
- `make fwi-on DATE=YYYYMMDD` → Fetches a recent daily FWI grid (only available for recent LIVE days on website).  
- `make fwi-batch` → Downloads multiple specified daily grids. (only available for recent LIVE days on website, specified within makefile). 

### NBAC (National Burned Area Composite, 30m, 1972–2024)
- `make nbac-30m` → Downloads the **national mosaic (ZIP)** and extracts it.  
- `make nbac-30m-clean` → Removes only the downloaded ZIP (keeps extracted data).  

### FBP Fuel Types (100m EPSG:3978, 20240527)
- `make fbp-fueltypes` → Downloads the **FBP fuel types raster**. 

> ⚠️ Note: Each dataset folder contains a README with dataset-specific details and usage commands.

---

## Usage Examples

```bash
# Fetch everything (NFDB, FWI archive, NBAC, FBP fuel types)
make all DATE=20230604

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
