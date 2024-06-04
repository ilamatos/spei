<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->



<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->


<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/ilamatos/spei">
    <img src="figures/LEV1_ingles_branco_300dpi.tif" alt="Logo" width="100" height="80">
  </a>

<h3 align="center">SPEI - Standardized Precipitation Evapotransporation Index</h3>

  <p align="center">
   Data and Rcode to reproduce analysis of the manuscript entitled "On  the need to use proper metrics to detect experimental drought treatments - a comment on Keen et al. (2024)"
    <br />
    <a href="https://github.com/ilamatos/spei"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ilamatos/spei">View Demo</a>
    ·
    <a href="https://github.com/ilamatos/spei/issues">Report Bug</a>
    ·
    <a href="https://github.com/ilamatos/spei/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
    <li>
      <a href="#about-the-project">About the project </a>
      </ul>
    <li>
      <a href="#getting-started">Getting Started</a>
      </ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
  <li>
      <a href="#statistical-analysis">Statistical Analysis</a>
    </ul>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project
Recently, Keen et al. (2024) evaluated the combined effect of experimental fire and drought events on the encroachment of tallgrass prairie vegetation. By using passive rainout shelters to impose the drought treatment, they found that moderate drought in combination with fire was not sufficient to reduce biomass production or stem density in an encroaching clonal shrub. However, we noticed that the authors inferred drought based on 50% PPT reduction and on changes in soil moisture between control and drought plots. Because they did not use standardized indices (e.g. standardized precipitation evapotranspiration index, SPEI) to properly detect drought intensity, it is unclear whether their drought plots experienced a real drought and whether their control plots experienced near-average mean annual precipitation throughout the experimental period. We reanalyzed Keen et al. (2024) data using SPEI and found that drought plots were subjected to moderate/severe drought, whereas control plots failed to replicate the near-average conditions of the studied area (i.e. they either experienced ‘too’ dry or ‘too’ wet conditions). Consequently, some of their results require a reinterpretation, as for most of the experimental period they were comparing control plots suffering a moderate natural drought versus drought plots reaching moderate/severe drought intensity . We discuss the importance of standardized climatic indices (such as SPEI) as an informative metric to quantify drought intensity in rainfall manipulative experiments and provide additional guidelines to improve how future rainfall manipulation studies impose and detect drought in treatment and control plots.

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

You will need R version 4.3.1 (or greater) and the R-packages listed below installed and loaded in your computer to run the Rcode to reproduce the analysis of this project

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/ilamatos/spei.git
   ```
2. Install the necessary R-packages
   ```sh
   install.packages(c("tidyverse", "lubridate", "ggpubr", "ggpmisc", "SPEI", "sf, "rnaturalearth", "remotes", "pacman"))
   ```
   Some packages may need to be installed from the source
   
    ```sh
   # installing climateR package 
   library(remotes)
   remotes::install_github("mikejohnson51/AOI")

   # loading all necessary packages
   library(pacman)
   pacman::p_load(tidyverse, lubridate, ggpubr, ggpmisc, SPEI, sf, rnaturalearth, climateR) 
    
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- STATISTICAL ANALYSIS -->
## Statistical analysis

To calculate SPEI for a given study area, a historical record of monthly precipitation and potential evapotranspiration is required.
In this tutorial, we use climatic water balance data from TerraClimate (https://www.climatologylab.org/terraclimate.html), which provides long-term data (1959-present) at a spatial resolution of 2.5 arc minutes (~ 4 km; Abatzoglou, Dobrowski, Parks, & Hegewisch, 2018).

We use the R-package ClimateR (github/mikejohnson51/climateR) to download monthly precipitation and potential evapotranspiration data for the study area of Keen et al. (2024) study, which was conducted at Konza Prairie Biological Station (Kansas, US).

To download climate data for this study site we only need to provide: 

* []()1. Decimal coordinates for study area: 39.103784, -96.613075;
* []()2. Which variables we want to download: pr (monthly precipitation) and pet (potential evapotranspiration);
* []()3. Start date: 1959-01-01
* []()4. End date: 2023-12-31

First, we need to use the code below to convert the study area coordinates into a spatial (sf) object
```sh
# create a dataframe with study area coordinates
site_coord <- data.frame(name = "Konza", 
                     lon = -96.613075, 
                     lat = 39.103784)
# convert the dataframe into a sf object
site_sf <- sf::st_as_sf(site_coord, 
                       coords = c("lon", "lat"),
                       crs = 4269) 
```





<!-- FIGURE 1 -->
<br />
<div align="left">
  <a href="https://github.com/ilamatos/xylem_implosion_safety">
    <img src="figures/Figure_1.png" alt="Logo" width="2500" height="500">
  </a>

<h3 align="left">Figure 1</h3>



<!-- CONTACT -->
## Contact

Ilaine Silveira Matos - ilaine.matos@gmail.com

Project Link: [https://github.com/ilamatos/xylem_implosion_safety](https://github.com/ilamatos/xylem_implosion_safety)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- REFERENCES -->
## References

* []()Benjamini Y and Hochberg Y (1995) Journal of the Royal Statistical Society Series B
* []()Blackman CJ et al (2010) New Phytologist
* []()Blackman CJ et al (2018) Annals of Botany
* []()Brodribb TJ and Holbrook MN (2005) Plant Physiology
* []()Escheverria A et al (2022) American Journal of Botany
* []()Hacke UG et al (2001) Oecologia 
* []()Hacke UG et al (2004) American Journal of Botany
* []()Jacobson AL et al (2005) Plant Physiology
* []()Pittermann J et al (2016) Plant Cell and Environment
* []()Pratt RB and Jacobsen AL (2017)
* []()R Foundation for Statistical Computing (2023) Plant Cell and Environment
* []()Sperry JS (2003) International Journal of Plant Sciences
* []()Sperry JS and Hacke UG (2004) American Journal of Botany
* []()Sperry JS et al (2006) American Journal of Botany
* []()Warton DI et al (2011) Methods in Ecology and Evolution
* []()Zhang YJ et al (2023) New Phytologist
<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ilamatos/xylem_implosion_safety.svg?style=for-the-badge
[contributors-url]: https://github.com/ilamatos/xylem_implosion_safety/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ilamatos/xylem_implosion_safety.svg?style=for-the-badge
[forks-url]: https://github.com/ilamatos/xylem_implosion_safety/network/members
[stars-shield]: https://img.shields.io/github/stars/ilamatos/xylem_implosion_safety.svg?style=for-the-badge
[stars-url]: https://github.com/ilamatos/xylem_implosion_safety/stargazers
[issues-shield]: https://img.shields.io/github/issues/ilamatos/xylem_implosion_safety.svg?style=for-the-badge
[issues-url]: https://github.com/ilamatos/xylem_implosion_safety/issues
[license-shield]: https://img.shields.io/github/license/ilamatos/xylem_implosion_safety.svg?style=for-the-badge
[license-url]: https://github.com/ilamatos/xylem_implosion_safety/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
[product-screenshot]: images/screenshot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
