package com.quilt.dao;

import com.quilt.entity.Log;
import com.quilt.entity.Photos;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface PhotosDAO {
    /**
     *
     */
    int deleteByPrimaryKey(Integer id);

    /**
     *
     */
    int insert(Photos record);

    /**
     *
     */
    int insertSelective(Photos record);

    /**
     *
     */
    Log selectByPrimaryKey(Photos id);

    /**
     *
     */
    int updateByPrimaryKeySelective(Photos record);

    /**
     *
     */
    int updateByPrimaryKey(Photos record);

    List<Photos> getAllPhotos();

    int getPhotosCount();



}
