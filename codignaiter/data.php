<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Data extends CI_Model {
	public function kategoribyproduk(){
		$data=$this->db->query("select distinct idkategori,kategori from produk where st='1' and thumbnail<>''");
		$this->db->close();
		return $data->result();
	}
	public function produkbykategori($id){
		$data=$this->db->query("select * from produk where idkategori='".$id."' and thumbnail<>'' and st='1' limit 0,5");
		$this->db->close();
		return $data->result();
	}
	public function cabang(){
		$data=$this->db->query("select * from cabang");
		$this->db->close();
		return $data->result();
	}
	public function login($username,$password){
		$data=$this->db->query("select * from signin where userid='".$username."' and pass='".$password."'");
		$this->db->close();
		return $data->result();
	}
	public function cabangbyuserid($userid){
		$data=$this->db->query("select * from cabang where userid='".$userid."'");
		$this->db->close();
		return $data->result();
	}
	public function pelangganbyuserid($userid){
		$data=$this->db->query("select * from pelanggan where userid='".$userid."'");
		$this->db->close();
		return $data->result();
	}
}
