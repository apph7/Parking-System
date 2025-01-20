package com.quilt.entity;

import java.util.Date;

public class User {
    /**
     * �û�ID
     */
    private Integer id;

    /**
     * ��¼�û���
     */
    private String username;

    /**
     * ��¼����
     */
    private String password;

    /**
     * �û�ͷ��
     */
    private String headPic;

    /**
     * �û��ǳ�
     */
    private String userNickname;

    /**
     * �û�ǩ��
     */
    private String userSignature;

    /**
     * �û�����
     */
    private String userEmail;

    /**
     * �û���ǩ
     */
    private String userTag;

    /**
     * ����ʱ��
     */
    private Date createTime;

    /**
     * ��ȡ�ֶ�id���û�ID����ֵ
     */
    public Integer getId() {
        return id;
    }

    /**
     * �����ֶ�id���û�ID����ֵ
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * ��ȡ�ֶ�username����¼�û�������ֵ
     */
    public String getUsername() {
        return username;
    }

    /**
     * �����ֶ�username����¼�û�������ֵ
     */
    public void setUsername(String username) {
        this.username = username == null ? null : username.trim();
    }

    /**
     * ��ȡ�ֶ�password����¼���룩��ֵ
     */
    public String getPassword() {
        return password;
    }

    /**
     * �����ֶ�password����¼���룩��ֵ
     */
    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    /**
     * ��ȡ�ֶ�head_pic���û�ͷ�񣩵�ֵ


    public String getHeadPic() {
        return headPic;
    }  */

    /**
     * �����ֶ�head_pic���û�ͷ�񣩵�ֵ

    public void setHeadPic(String headPic) {
        this.headPic = headPic == null ? null : headPic.trim();
    }
*/
    /**
     * ��ȡ�ֶ�user_nickname���û��ǳƣ���ֵ
     */
    public String getUserNickname() {
        return userNickname;
    }

    /**
     * �����ֶ�user_nickname���û��ǳƣ���ֵ
     */
    public void setUserNickname(String userNickname) {
        this.userNickname = userNickname == null ? null : userNickname.trim();
    }

    /**
     * ��ȡ�ֶ�user_signature���û�ǩ������ֵ
     */
    public String getUserSignature() {
        return userSignature;
    }

    /**
     * �����ֶ�user_signature���û�ǩ������ֵ
     */
    public void setUserSignature(String userSignature) {
        this.userSignature = userSignature == null ? null : userSignature.trim();
    }

    /**
     * ��ȡ�ֶ�user_email���û����䣩��ֵ
     */
    public String getUserEmail() {
        return userEmail;
    }

    /**
     * �����ֶ�user_email���û����䣩��ֵ
     */
    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail == null ? null : userEmail.trim();
    }

    /**
     * ��ȡ�ֶ�user_tag���û���ǩ����ֵ
     */
    public String getUserTag() {
        return userTag;
    }

    /**
     * �����ֶ�user_tag���û���ǩ����ֵ
     */
    public void setUserTag(String userTag) {
        this.userTag = userTag == null ? null : userTag.trim();
    }

    /**
     * ��ȡ�ֶ�create_time������ʱ�䣩��ֵ
     */
    public Date getCreateTime() {
        return createTime;
    }

    /**
     * �����ֶ�create_time������ʱ�䣩��ֵ
     */
    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getHeadPic() {
        return headPic;
    }

    public void setHeadPic(String headPic) {
        this.headPic = headPic;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", headPic='" + headPic + '\'' +
                ", userNickname='" + userNickname + '\'' +
                ", userSignature='" + userSignature + '\'' +
                ", userEmail='" + userEmail + '\'' +
                ", userTag='" + userTag + '\'' +
                ", createTime=" + createTime +
                '}';
    }
}