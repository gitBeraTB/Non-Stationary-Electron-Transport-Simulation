# Non-Stationary Electron Transport Simulation in MATLAB

This repository contains a numerical simulation of **non-stationary electron transport** in direct bandgap semiconductors. It solves the **Boltzmann Transport Equations** using the Euler Method to analyze phenomena such as **Velocity Overshoot** and **Energy Relaxation** in the picosecond timescale.

## 🚀 Project Overview
As semiconductor devices scale down to the nanometer regime, steady-state drift-diffusion models become insufficient. This project models the transient response of electrons to rapidly changing electric fields, which is critical for designing **High-Frequency (THz)** and **III-V HEMT** devices used in modern optical and satellite communications.

### Key Features
* **Physics Modeling:** Solves coupled differential equations for Drift Velocity, Average Energy, and Relaxation Times.
* **Algorithm:** Implements a time-stepped **Euler Method** simulation (1fs step size).
* **Visualization:** Automatically plots E-Field response, Effective Mass changes, and Velocity Overshoot characteristics.

## 📂 Repository Contents
* `electron_simulation.m`: The core MATLAB script performing the numerical analysis.
* `Project_Report.pdf`: Detailed academic paper explaining the theoretical background and result analysis.

## 🛠️ Technologies
* **Language:** MATLAB
* **Domain:** Solid State Devices, Computational Physics, Semiconductor Theory

## 📊 Results
The simulation demonstrates that rapid changes in the Electric Field lead to a "Velocity Overshoot" effect, allowing electrons to temporarily exceed saturation velocity—a key principle leveraged in high-speed silicon engineering.

---
*Author: Yusuf Berat Bölükbaş*
"This project was developed as part of the EE419 Solid State Devices course at Middle East Technical University."
