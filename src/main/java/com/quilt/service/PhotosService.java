package com.quilt.service;


import com.quilt.entity.Photos;
import com.quilt.entity.PhotosWithBLOBs;
import com.quilt.entity.UserWithBLOBs;

import java.util.List;

public interface PhotosService {
    /**
     * 添加
     */
    int addPhotos(Photos photos);

    /**
     * 删除
     */
    int deletePhotos(Integer id);

    /**
     * 得到所有相册
     */
    List<Photos> getAllPhotos();

    /**
     * 得到相册总数
     * @return
     */
    int getPhotosCount();
    int modPhotosInfo(PhotosWithBLOBs photosWithBLOBs);

}
