class OrderModel {
  String ID,
      post_author,
      post_date,
      post_date_gmt,
      post_content,
      post_title,
      post_excerpt,
      post_status,
      comment_status,
      ping_status,
      post_name,
      to_ping,
      pinged,
      post_modified,
      post_modified_gmt,
      post_content_filtered,
      post_parent,
      guid,
      menu_order,
      post_type,
      post_mime_type,
      comment_count,
      filter,
      total,
      status,
      status_code,
      status_text,
      schedule_order,
      delivery_time,
      address_id,
      lat,
      long,
      city,
      area,
      address,
      is_favorite;
  List products_ids;

  OrderModel(
      this.ID,
      this.post_author,
      this.post_date,
      this.post_date_gmt,
      this.post_content,
      this.post_title,
      this.post_excerpt,
      this.post_status,
      this.comment_status,
      this.ping_status,
      this.post_name,
      this.to_ping,
      this.pinged,
      this.post_modified,
      this.post_modified_gmt,
      this.post_content_filtered,
      this.post_parent,
      this.guid,
      this.menu_order,
      this.post_type,
      this.post_mime_type,
      this.comment_count,
      this.filter,
      this.total,
      this.status,
      this.status_code,
      this.status_text,
      this.schedule_order,
      this.delivery_time,
      this.address_id,
      this.lat,
      this.long,
      this.city,
      this.area,
      this.address,
      this.is_favorite,
      this.products_ids);
}
