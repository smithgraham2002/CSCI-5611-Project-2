public int ropes = 40;
public int rope_len = 80;
public Node[][] nodes = new Node[ropes][rope_len];
PrintWriter len_err;
PrintWriter energy;
public Vec2 circ_pos = new Vec2(2, 2);
public float circ_r = 2;
boolean click_circ = false;
Vec2 mouse_pos = new Vec2(0, 0);


void setup() {
  size(500, 500);
  scene_scale = width / 10.0f;
  float x = 5;
  for (int i = 0; i < ropes; i++) {
    x = 5 + link_length * i;
    for (int j = 0; j < rope_len; j++) {
      nodes[i][j] = new Node(new Vec2(x, 5));
      x += link_length;
    }
  }
  len_err = createWriter("len_err.txt");
  energy = createWriter("energy.txt");
}

class Node {
  Vec2 pos;
  Vec2 vel;
  Vec2 last_pos;
  boolean up;
  boolean left;
  
  Node(Vec2 pos) {
    this.pos = pos;
    this.vel = new Vec2(0, 0);
    this.last_pos = pos;
    this.up = true;
    this.left = true;
  }
}

Vec2 base_pos = new Vec2(5, 5);
float link_length = 0.06;
float diag_len = sqrt(link_length * link_length + link_length * link_length);
Vec2 g = new Vec2(0, 10);
float scene_scale = width / 10.0f;
int relax_steps = 10;
int sub_steps = 10;
Vec2 delta_mouse = new Vec2(0, 0);

void update_physics(float dt) {
  for (int i = 0; i < ropes; i++) {
    for (int j = 1; j < rope_len; j++) {
      nodes[i][j].last_pos = nodes[i][j].pos;
      nodes[i][j].vel = nodes[i][j].vel.plus(g.times(dt));
      nodes[i][j].pos = nodes[i][j].pos.plus(nodes[i][j].vel.times(dt));
    } 
  }
  
  collisionDetection();
  //clothCollisions();

  
  Vec2 delta;
  float delta_len;
  float correction;
  Vec2 delta_normalized;
  
  for (int r = 0; r < relax_steps; r++) {
    for (int i = 0; i < ropes; i++) {
      for (int j = 1; j < rope_len; j++) {
        delta = nodes[i][j].pos.minus(nodes[i][j - 1].pos);
        delta_len = delta.length();
        if (delta_len > 5 * link_length) {
          nodes[i][j].up = false;
        }
        if (nodes[i][j].up) {
          correction = delta_len - link_length;
          delta_normalized = delta.normalized();
          nodes[i][j].pos = nodes[i][j].pos.minus(delta_normalized.times(correction / 2));
          nodes[i][j - 1].pos = nodes[i][j - 1].pos.plus(delta_normalized.times(correction / 2));
        }  
      }
      nodes[i][0].pos = new Vec2(base_pos.x + i * link_length, base_pos.y);
    }
  }
  for (int r = 0; r < relax_steps; r++) {
    for (int i = 1; i < ropes; i++) {
      for (int j = 0; j < rope_len; j++) {
        delta = nodes[i][j].pos.minus(nodes[i - 1][j].pos);
        delta_len = delta.length();
        if (delta_len > 5 * link_length) {
          nodes[i][j].left = false;
        }
        if (nodes[i][j].left) {
          correction = delta_len - link_length;
          delta_normalized = delta.normalized();
          nodes[i][j].pos = nodes[i][j].pos.minus(delta_normalized.times(correction / 2));
          nodes[i - 1][j].pos = nodes[i - 1][j].pos.plus(delta_normalized.times(correction / 2));
        }
      }
    }
  }
  //for (int r = 0; r < relax_steps; r++) {
  //  for (int i = 1; i < ropes; i++) {
  //    for (int j = 1; j < rope_len; j++) {
  //      delta = nodes[i][j].pos.minus(nodes[i - 1][j - 1].pos);
  //      delta_len = delta.length();
  //      correction = delta_len - diag_len + 0.1;
  //      delta_normalized = delta.normalized();
  //      nodes[i][j].pos = nodes[i][j].pos.minus(delta_normalized.times(correction / 2));
  //      nodes[i - 1][j - 1].pos = nodes[i - 1][j - 1].pos.plus(delta_normalized.times(correction / 2));
  //    }
  //  }
  //}
  //for (int r = 0; r < relax_steps; r++) {
  //  for (int i = 0; i < ropes - 1; i++) {
  //    for (int j = 0; j < rope_len - 1; j++) {
  //      delta = nodes[i][j].pos.minus(nodes[i][j].pos);
  //      delta_len = delta.length();
  //      correction = delta_len - diag_len + 0.1;
  //      delta_normalized = delta.normalized();
  //      nodes[i + 1][j].pos = nodes[i + 1][j].pos.minus(delta_normalized.times(correction / 2));
  //      nodes[i][j + 1].pos = nodes[i][j + 1].pos.plus(delta_normalized.times(correction / 2));
  //    }
  //  }
  //}
  
  
  for (int i = 0; i < ropes; i++) {
    for (int j = 0; j < rope_len; j++) {
      nodes[i][j].vel = nodes[i][j].pos.minus(nodes[i][j].last_pos).times(1 / dt);
    }
  }
  
  if (mousePressed == true) {
    if (click_circ == true) {
      delta_mouse.x = mouseX / scene_scale - mouse_pos.x;
      delta_mouse.y = mouseY / scene_scale - mouse_pos.y;
      circ_pos.add(delta_mouse);
      mouse_pos.x = mouseX / scene_scale;
      mouse_pos.y = mouseY / scene_scale;
    } else {
      mouse_pos.x = mouseX / scene_scale;
      mouse_pos.y = mouseY / scene_scale;
      if (circ_pos.distanceTo(mouse_pos) < circ_r) {
        click_circ = true;
      }
    }
  } else if (mousePressed == false) {
    click_circ = false;
  }
}

boolean paused = false;

void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  if (key == 's') {
    len_err.flush();
    len_err.close();
    energy.flush();
    energy.close();
    exit();
  }
  if (keyCode == LEFT) {
    for (int i = 0; i < ropes; i++) {
      for (int j = 0; j < rope_len; j++) {
        nodes[i][j].vel.add(new Vec2(-3, 0));
      }
    }
  }
  if (keyCode == RIGHT) {
    for (int i = 0; i < ropes; i++) {
      for (int j = 0; j < rope_len; j++) {
        nodes[i][j].vel.add(new Vec2(3, 0));
      }
    }
  }
}

float time = 0;
void draw() {
  //if (millis() >= 30000) {
  //  len_err.flush();
  //  len_err.close();
  //  energy.flush();
  //  energy.close();
  //  exit();
  //}
  float dt = 1.0 / 20;
  
  if (!paused) {
    for (int i = 0; i < sub_steps; i++) {
      time += dt / sub_steps;
      update_physics(dt / sub_steps);
    }
  }
  

  
  background(255);
  stroke(0);
  strokeWeight(2);
  
  //fill(0, 255, 0);
  //stroke(0);
  //strokeWeight(0.02 * scene_scale);
  //for(int n = 0; n < 20; n++){
  //  ellipse(nodes[n].pos.x * scene_scale, nodes[n].pos.y * scene_scale, 0.3 * scene_scale, 0.3 * scene_scale);
  //}
  
  stroke(0);
  fill(255, 0, 0);
  ellipse(circ_pos.x * scene_scale, circ_pos.y * scene_scale, circ_r * scene_scale, circ_r * scene_scale);
  
  stroke(0);
  strokeWeight(0.02 * scene_scale);
  for (int i = 0; i < ropes; i++) {
    for (int j = 1; j < rope_len; j++) {
      if (nodes[i][j].up) {
        line(nodes[i][j - 1].pos.x * scene_scale, nodes[i][j - 1].pos.y * scene_scale, nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale);
      }
    }
  }
  for (int i = 1; i < ropes; i++) {
    for (int j = 0; j < rope_len; j++) {
      if (nodes[i][j].left) {
        line(nodes[i - 1][j].pos.x * scene_scale, nodes[i - 1][j].pos.y * scene_scale, nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale);
      }
    }
  }
  //for (int i = 1; i < ropes; i++) {
  //  for (int j = 1; j < rope_len; j++) {
  //    line(nodes[i - 1][j - 1].pos.x * scene_scale, nodes[i - 1][j - 1].pos.y * scene_scale, nodes[i][j].pos.x * scene_scale, nodes[i][j].pos.y * scene_scale);
  //  }
  //}
  //for (int i = 0; i < ropes - 1; i++) {
  //  for (int j = 0; j < rope_len - 1; j++) {
  //    line(nodes[i][j + 1].pos.x * scene_scale, nodes[i][j + 1].pos.y * scene_scale, nodes[i + 1][j].pos.x * scene_scale, nodes[i + 1][j].pos.y * scene_scale);
  //  }
  //}
}

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public Vec2() {
    this.x = 0;
    this.y = 0;
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public float lengthSqr(){
    return x * x + y * y;
  }
  
  public Vec2 plus(Vec2 vec){
    return new Vec2(x+vec.x, y+vec.y);
  }
  
  public void add(Vec2 vec){
    x += vec.x;
    y += vec.y;
  }
  
  public Vec2 minus(Vec2 vec){
    return new Vec2(x-vec.x, y-vec.y);
  }
  
  public void subtract(Vec2 vec){
    x -= vec.x;
    y -= vec.y;
  }
  
  public Vec2 times(float scal){
    return new Vec2(x*scal, y*scal);
  }
  
  public void mul(float scal){
    x *= scal;
    y *= scal;
  }
  
  public void clampToLength(float max){
    float mag = sqrt(x*x+y*y);
    if (mag > max){
      x *= max/mag;
      y *= max/mag;
    }
  }
  
  public void setToLength(float len){
    float mag = sqrt(x*x+y*y);
    x *= len/mag;
    y *= len/mag;
  }
  
  public void normalize(){
    float mag = sqrt(x*x+y*y);
    x /= mag;
    y /= mag;
  }
  
  public Vec2 normalized(){
    float mag = sqrt(x*x+y*y);
    return new Vec2(x/mag, y/mag);
  }
  
  public float distanceTo(Vec2 vec){
    float dx = vec.x - x;
    float dy = vec.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x+a.y*b.y;
}

float cross(Vec2 v1, Vec2 v2){
  return v1.x*v2.y-v1.y*v2.x;
}
