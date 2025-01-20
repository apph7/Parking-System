package com.quilt.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;
public class ParkingRecord {
    private Long id; // 确保字段存在
    private String licensePlate;
    private Long parkingSpotId;
    private Timestamp entryTime;
    private Timestamp exitTime;
    private BigDecimal fee;

    // Getter 和 Setter 方法
    public Long getId() {
        return id;
    }

    public void setId(Long id) { // 确保方法名称和参数类型正确
        this.id = id;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public Long getParkingSpotId() {
        return parkingSpotId;
    }

    public void setParkingSpotId(Long parkingSpotId) {
        this.parkingSpotId = parkingSpotId;
    }

    public Timestamp getEntryTime() {
        return entryTime;
    }

    public void setEntryTime(Timestamp entryTime) {
        this.entryTime = entryTime;
    }

    public Timestamp getExitTime() {
        return exitTime;
    }

    public void setExitTime(Timestamp exitTime) {
        this.exitTime = exitTime;
    }

    public BigDecimal getFee() {
        return fee;
    }

    public void setFee(BigDecimal fee) {
        this.fee = fee;
    }
    @Override
    public String toString() {
        return "ParkingRecord{" +
                "id=" + id +
                ", licensePlate='" + licensePlate + '\'' +
                ", parkingSpotId=" + parkingSpotId +
                ", entryTime=" + entryTime +
                ", exitTime=" + exitTime +
                ", fee=" + fee +
                '}';
    }


}
