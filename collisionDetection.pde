void collisionDetection() {
  Vec2 to_c = new Vec2();
  for (int i = 0; i < ropes; i++) {
    for (int j = 0; j < rope_len; j++) {
      to_c = nodes[i][j].pos.minus(circ_pos);
      float len = to_c.length();
      float correction = len - circ_r / 2 - 0.06;
      if(correction < 0) {
        to_c.normalize();
        to_c.mul(correction);
        nodes[i][j].pos.subtract(to_c);
      }
    }
  }
}

//void clothCollisions() {
//  Vec2 to_node = new Vec2();
//  for (int i = 0; i < ropes; i++) {
//    for (int j = 0; j < rope_len; j++) {
//      for (int h = 0; h < ropes; h++) {
//        for (int k = 0; k < rope_len; k++) {
//          to_node = nodes[i][j].pos.minus(nodes[h][k].pos);
//          float len = to_node.length();
//          float correction = len - 0.04;
//          if (correction < 0) {
//            to_node.normalize();
//            to_node.mul(correction);
//            nodes[i][j].pos.subtract(to_node.times(0.5));
//            nodes[h][k].pos.add(to_node.times(0.5));
//          }
//        }
//      }
//    }
//  }
//}
