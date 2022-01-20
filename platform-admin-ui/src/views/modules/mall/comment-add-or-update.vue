<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="评价内容" prop="content">
        <el-input type="textarea" v-model="dataForm.content" :disabled="disabled"
                  placeholder="评价内容，储存为BASE64编码"></el-input>
      </el-form-item>
      <el-form-item label="评价图片" prop="content">
        <img v-show="dataForm.commentPictureEntityList.length>0"
             v-for="commentPicture in dataForm.commentPictureEntityList" :key="commentPicture.id" class="comment-img"
             @click="openImg(commentPicture.picUrl)" :src="commentPicture.picUrl"/>
        <el-alert v-show="dataForm.commentPictureEntityList.length===0"
                  title="没有图片..." :closable="false"
                  type="error">
        </el-alert>
      </el-form-item>
      <el-form-item label="评价级别" prop="content">
        <el-rate
          disabled
          v-model="dataForm.evalLevel">
        </el-rate>
      </el-form-item>
      <el-form-item label="配送质量" prop="content">
        <el-rate
          disabled
          v-model="dataForm.deliveryLevel">
        </el-rate>
      </el-form-item>
      <el-form-item label="商品服务" prop="content">
        <el-rate
          disabled
          v-model="dataForm.goodsLevel">
        </el-rate>
      </el-form-item>
      <el-form-item label="类型" prop="type">
        <el-radio-group v-model="dataForm.type" :disabled="disabled">
          <el-radio :label="0">商品</el-radio>
          <el-radio :label="1">文章</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="dataForm.status" :disabled="disabled">
          <el-radio :label="0">待审核</el-radio>
          <el-radio :label="1">审核通过</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="记录时间" prop="addTime">
        <el-date-picker type="datetime" v-model="dataForm.addTime" :disabled="disabled"
                        placeholder="记录时间"></el-date-picker>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
      <el-button v-if="!disabled" type="primary" @click="dataFormSubmit()">确定</el-button>
    </span>
  </el-dialog>
</template>

<script>
export default {
  data () {
    return {
      disabled: false,
      visible: false,
      dataForm: {
        id: '',
        userId: '',
        goodsId: '',
        goodsSpecifitionNameValue: '',
        content: '',
        type: '',
        addTime: '',
        status: '',
        commentPictureEntityList: []
      },
      dataRule: {
        name: [
          {
            required: true,
            message: '名称不能为空',
            trigger: 'blur'
          }
        ]
      }
    }
  },
  methods: {
    init (id, disabled) {
      this.disabled = disabled
      this.dataForm.id = id || ''
      this.visible = true
      this.$nextTick(() => {
        this.$refs['dataForm'].resetFields()
        if (this.dataForm.id) {
          this.$http({
            url: `/mall/comment/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.comment
            }
          })
        }
      })
    },
    // 表单提交
    dataFormSubmit () {
      this.$refs['dataForm']
        .validate((valid) => {
          if (valid) {
            this.$http({
              url: `/mall/comment/${!this.dataForm.id ? 'save' : 'update'}`,
              method: 'post',
              data: this.dataForm
            }).then(({data}) => {
              if (data && data.code === 0) {
                this.$message({
                  message: '操作成功',
                  type: 'success',
                  duration: 1500
                })
                this.visible = false
                this.$emit('refreshDataList')
              }
            })
          }
        })
    }
  }
}
</script>
<style>
.comment-img {
  width: 100px;
  height: 100px;
}
</style>
