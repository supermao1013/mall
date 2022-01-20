<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form inline :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="关键词" prop="keyword">
        <el-input v-model="dataForm.keyword" :disabled="disabled" placeholder="关键词"></el-input>
      </el-form-item>
      <el-form-item label="搜索来源" prop="searchFrom">
        <el-radio-group v-model="dataForm.searchFrom" :disabled="disabled">
          <el-radio :label="1">微信小程序</el-radio>
          <el-radio :label="2">微信公众号</el-radio>
          <el-radio :label="3">APP</el-radio>
          <el-radio :label="4">H5</el-radio>
          <el-radio :label="5">支付宝小程序</el-radio>
          <el-radio :label="6">QQ小程序</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="搜索时间" prop="addTime">
        <el-date-picker type="datetime" v-model="dataForm.addTime" :disabled="disabled"
                        placeholder="搜索时间"></el-date-picker>
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
        keyword: '',
        searchFrom: '',
        addTime: ''
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
            url: `/mall/searchhistory/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.searchhistory
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
              url: `/mall/searchhistory/${!this.dataForm.id ? 'save' : 'update'}`,
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
