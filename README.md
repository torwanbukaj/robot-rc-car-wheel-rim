# Customizable robot / RC car wheel rim

![Example rim design](img/rim_example_openscad.png?raw=true)

This OpenSCAD project can be used for designing your custom robot or RC car wheel rim which you can then 3D print and use with a tire of your choice.

## How does it work?
1. You will need OpenSCAD - download it from here: https://openscad.org/downloads.html,
2. Take measurements of your tire,
3. Modify OpenSCAD project file "variables" (these are not technically variables but let's call them like this) in "Tire and rim dimensions" section according to your measurements (find the project file in the "src" directory of this repository),
3. Render the final shape (F6), generate STL file (F7), slice it with a slicer of your selection and just 3D print :)

## Taking measurements

- This is how you should measure tire inner diameter:

![How to measure tire_inner_dia](img/tire_inner_dia_meas_500px.png?raw=true)

I recommend increasing the measured value by a few percent. In the example from the picture the measured diameter was 46mm (you may not see it on the picture above due to the parallax error). Finally, I used 50mm in the target design of the rim ( tire_inner_dia = 50; ). In general, account for flexibility of the tires you have.
