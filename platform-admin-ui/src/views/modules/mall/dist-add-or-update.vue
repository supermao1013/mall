<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form inline :model="dataForm" :rules="dataRule" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="会员昵称" prop="userId">
        <el-input v-model="dataForm.nickname" :disabled="true" placeholder="会员昵称"></el-input>
      </el-form-item>
      <el-form-item label="上级分销" prop="superiorId">
        <el-input v-model="dataForm.superiorNickname" :disabled="true" placeholder="上级分销"></el-input>
      </el-form-item>
      <el-form-item label="审核状态" prop="isAudit">
        <el-radio-group v-model="dataForm.isAudit" :disabled="disabled">
          <el-radio :label="false">未审核</el-radio>
          <el-radio :label="true">已审核</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="加入时间" prop="joinTime">
        <el-input v-model="dataForm.joinTime" :disabled="true" placeholder="加入时间"></el-input>
      </el-form-item>
      <el-form-item label="待取佣金" prop="amountAvailable">
        <el-input v-model="dataForm.amountAvailable" :disabled="disabled" placeholder="待取佣金"></el-input>
      </el-form-item>
      <el-form-item label="已取佣金" prop="amountWithdrawn">
        <el-input v-model="dataForm.amountWithdrawn" :disabled="disabled" placeholder="已取佣金"></el-input>
      </el-form-item>
      <el-form-item label="累计佣金" prop="amountTotal">
        <el-input v-model="dataForm.amountTotal" :disabled="disabled" placeholder="累计佣金"></el-input>
      </el-form-item>
      <el-form-item label="邀请码" prop="invitationCode">
        <el-input v-model="dataForm.invitationCode" :disabled="disabled" placeholder="邀请码"></el-input>
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
        id: 0,
        userId: '',
        superiorId: '',
        nickname: '',
        superiorNickname: '',
        isAudit: '',
        joinTime: '',
        amountAvailable: '',
        amountWithdrawn: '',
        amountTotal: '',
        invitationCode: ''
      },
      dataRule: {
        name: [
          {required: true, message: '名称不能为空', trigger: 'blur'}
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
            url: `/mall/dist/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.dist
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
              url: `/mall/dist/${!this.dataForm.id ? 'save' : 'update'}`,
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
