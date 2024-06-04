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
    <img src="figures/macrosystems_logo_long (1).png" alt="Logo" width="300" height="80">
  </a>

<h3 align="center">Leaf xylem implosion safety</h3>

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
      <a href="#statistical-analysis">Statistical Analysis</a>
    </ul>
    <li>
      <a href="#getting-started">Getting Started</a>
      </ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#references">References</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project
Vascular plants developed lignified conduits (tracheids and vessel elements) in the xylem tissue to transport water with relatively high efficiency (Sperry 2003). Because of the extreme negative pressures experienced in the xylem, these conduits are under risk of dysfunction (Figure 1a) either by cavitation (i.e. the collapse of water columns due to formation and expansion of air bubbles) or by implosion (i.e. the collapse of conduit walls due to compression forces) (Sperry and Hacke 2004, Hacke et al 2004). For a long time, physiological work on xylem dysfunction has focused on cavitation as the main process responsible for reduced hydraulic efficiency in plants under drought, while much less is know about the leaf xylem safety against implosion (Zhang et al 2023).

To a first approximation, conduit safety against implosion is proportional to the ratio between double-wall thickness (T in Figure 1) and maximum lumen diameter (D), i.e. T/D (also called ‘‘thickness-to-span’’ ratio, Hacke et al 2001, Sperry et al 2006). Thus, implosion safety can theoretically be increased either by having narrower conduits or by having thicker conduits (Jacobson et al 2005, Pittermann et al 2016). Either way (narrowing or thickening conduits) may result in functional disadvantages for the plant (Blackman et al 2010, Pittermann et al 2016, Pratt and Jacobsen 2017): narrowing conduits results in decreased flow efficiency (Sperry et al 2006), whereas thickening conduits results in increased construction cost (Brodribb and Holbrook 2005).

Therefore, plants may need to trade-off implosion safety  versus maximum efficiency at a minimum construction cost. Assuming linear trade-offs between those different leaf functions, we could expect leaves to scale T proportionally to D in order to achieve a level of conduit reinforcement (T/D) that is “just right” given the risk of failure relative to the fixed cost of construction (Hacke et al 2001, Escheverria et al 2022, Blackman et al 2018). That is, the relationship between log (T) vs. log (D) should have an allometric slope close to 1 (isometric growth) (Figure 1). If thickening occurs too fast (slope >1 = positive allometry), conduits might be more safe against implosion and also mechanically stronger, but they are also more costly to produce and less efficient in conducting water. If widening occurs too fast (slope <1 = negative allometry), conduits might be less costly to produce and more efficient in conducting water, but at the expense of being potentially more vulnerable to implosion and less mechanically reinforced.  

Species growing under different selective pressures may prioritize different leaf functions, so we should expect some developmental variation in the T x D scaling slopes across plant phylogeny (i.e. slope may depart from 1 in some species), creating an optimal range of scaling factors within boundary conditions set by biophysical and physiological constraints (Figure 1). For example, species growing in dry habitats experience more xylem tension (more negative water potentials) and are likely under higher selection pressure for developing safer vessels (thicker and/or narrower conduits) compared to species in wet environments (Blackman et al 2018). Similarly, xylem tension increases from the petiole to the minor veins, so we could expect a variation in implosion safety across vein orders.
This research project investigates leaf xylem implosion safety on a phylogenetically diverse set of 122 ferns and angiosperms species with different habitats and growth forms. For each species, we also measured traits describing leaf mechanical support, hydraulic efficiency and construction cost and tested for potential trade-offs between leaf functions. 

Specifically we asked: 
- (Q1) Do leaf conduits’ double cell wall thickness (T) and lumen maximum diameter (D) scale to each other isometrically (i.e. slope = 1)? 
- (Q2) How does the slope of the T vs. D scaling varies across species and clades, habitat (arid, mesic, hydric), growth forms (aquatic, herb, climbing, tree, shrub), and vein orders (major, medium, minor)?
- (Q3) Is there a multiple trade-off between implosion safety, mechanical support, hydraulic efficiency and construction cost?

<!-- FIGURE 1 -->
<br />
<div align="left">
  <a href="https://github.com/ilamatos/xylem_implosion_safety">
    <img src="figures/Figure_1.png" alt="Logo" width="2500" height="500">
  </a>

<h3 align="left">Figure 1</h3>
Scaling scenarios for the log–log relationship between leaf conduit double-wall thickness (T) and maximum lumen diameter (D) for three hypothetical species (yellow, green, and orange). (a) Species have same slope (b coefficient) but different y-intercepts (a coefficients): y-intercept >1 (yellow line) - conduits have thicker cell walls relative to their diameter (i.e. higher lignification), potentially resulting in higher implosion safety across the entire venation network; y-intercept =1 (green line) - conduits have lower degree of lignification; y-intercept < 1 (orange line) - conduits have thinner cells walls relative to their diameter (i.e. lower lignification), potentially resulting in lower implosion safety across the entire leaf venation network. (b) Illustrations of how conduits T and D are expected to vary across vein sizes in each of the three scaling scenarios with same slope but different y-intercepts. (c) Species have same y-intercept but different slopes: slope >1 (yellow line) - as conduits become wider their cell walls become proportionally thicker, resulting in greater xylem reinforcement and lower vulnerability to implosion in larger conduits; slope = 1 (green line ) - conduits diameter and thickness increase proportionally, resulting in a constant safety implosion across conduits of different diameters; slope < 1 (orange line) - as conduits become wider their cell walls become proportionally thinner, resulting in greater xylem reinforcement in smaller conduits, but potentially higher vulnerability to implosion in larger conduits. (d) Illustrations of how conduits T and D are expected to vary across vein sizes in each of the three scaling scenarios of same y-intercept but different slopes.

<p align="left">(<a href="#readme-top">back to top</a>)</p>

<!-- STATISTICAL ANALYSIS -->
## Statistical analysis

To test if T and D scale isometrically (i.e. slope =1; Question 1), we log10-transformed both variables and then used the SMATR R package (version 3, Warton et al 2011) to fit standardized major axis (SMA) regression models. Then, we used the function sma( log10(T) ~ log10(D), slope.test = 1) to test if the regression slope was significantly different from one. We also used SMA regressions to investigate whether the slopes of the T x D relationship differed across groups (sma ( log10(T) ~ log10(D) * groups)), i.e. across species, clades, habitats, growth forms, and vein orders (Question 2). For each SMA model, we checked the assumptions of normality and homoscedasticity of the residuals. Additionally, we performed Kruskal wallis tests followed by pairwise Wilcox tests with Benjamini and Hochberg (1995) p-value adjustment method to test for differences in the anatomical traits (i.e. conduit diameter, thickness, implosion safety and critical implosion pressure) across those groups. 

To investigate possible trade-offs among leaf functional traits (Question 3), we used two complementary approaches. First, we carried out a principal component analysis (PCA) using the ‘prcomp’ function in R. Prior to the PCA, we z-transformed all traits to both improve comparability among them and reduce bias towards traits with higher variance. We used the Broken Stick method for estimating the number of statistically significant principal components to be retained. Our PCA analysis was carried out with 108 out of the 122 studied species, as we removed the 14 species with missing data for ε. Second, we run simple least-squares regression models to test for pairwise trade-offs between implosion safety (response variable) and the other leaf traits (predictor variables). We also regressed Pcri1 and Pcr2 values to assess the relationship between the two different mechanical models of conduit collapse used in this study. All analyses were carried out using the R programming environment 4.3.1 (R Foundation for Statistical Computing 2023). Regressions or differences were considered to be significant if P < 0.05.

<!-- GETTING STARTED -->
## Getting Started

### Prerequisites

You will need R version 4.3.1 (or greater) and the following R-packages installed and loaded in your computer to run the Rcode to reproduce the analysis of this project

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/ilamatos/xylem_implosion_safety.git
   ```
2. Install the necessary R-packages
   ```sh
   install.packages(c("ggpubr", "viridis", "BIEN", "maps", "mapdata", "raster", "sp", "smatr", "vegan", "tidyverse", "readxl", "hrbrthemes", "hexbin"))
   ```
   Some packages may need to be installed from the source
   
    ```sh
   # installing V.PhyloMaker 2 
   library(devtools)
   devtools::install_github("jinyizju/V.PhyloMaker2")

   # installing and loading ggtree
   install.packages("BiocManager", repos = "https://cloud.r-project.org")
   library(BiocManager)
   BiocManager::install("ggtree")
    
   ```
4. Run the R-script "xylem_implosion_safety_v3.R"

<p align="right">(<a href="#readme-top">back to top</a>)</p>

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
