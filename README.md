# CSCI-5611-Project-2
Graham Smith
![image](https://github.com/smithgraham2002/CSCI-5611-Project-2/assets/103609167/a8a5fdcd-acd5-4f36-963d-9b1859fafe85)

Features:
1. Multiple Ropes: Multiple ropes are used to represent the threads of a cloth.
2. Cloth Simulation: The simulation features a cloth created by binding together many ropes. The cloth behaves realistically--draping over objects and swinging back and forth.
3. User Interaction: By clicking on the circle and dragging it, the user can move the circle around the screen. The circle can be used to manipulate the cloth. In addition, the left and right arrow keys will add horizontal velocity to the cloth in the negative or positive directions, respectively. This can be used to swing the cloth from side to side.
4. Ripping/Tearing: If the distance between two nodes in the cloth becomes too great, the link between them will be removed. This causes the cloth to look as though it is tearing under stress.

[![Full Demo](https://img.youtube.com/vi/<VIDEO_ID>/hqdefault.jpg)](https://youtube.com/shorts/lXtx30z4mqE?feature=share)

One of the biggest difficulties when creating the cloth simulation was getting it to interact properly with the circle. Even once the collision detection function was written, the cloth would often bunch together after hitting the circle. Eventually, after playing around with the collision detection and the properties of the ropes, the interactions became more realistic. In addition, allowing the circle to move when te user dragged it was harder than expected. After a while, I found that my problem was that the circle position was not being updated relative to the scene scale. After correcting this problem, the circle moved smoothly and interacted well with the cloth. 
