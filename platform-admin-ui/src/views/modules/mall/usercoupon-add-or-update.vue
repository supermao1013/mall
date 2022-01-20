<template>
  <el-dialog
    :title="!dataForm.id ? '新增' : !disabled ? '修改' : '查看'"
    :close-on-click-modal="false"
    :visible.sync="visible">
    <el-form :model="dataForm" ref="dataForm" @keyup.enter.native="dataFormSubmit()"
             label-width="80px">
      <el-form-item label="会员昵称" prop="nickname">
        <el-input v-model="dataForm.nickname" :disabled="disabled" placeholder="会员昵称"></el-input>
      </el-form-item>
      <el-form-item label="优惠券" prop="couponId">
        <el-input v-model="dataForm.title" :disabled="disabled" placeholder="优惠券"></el-input>
      </el-form-item>
      <el-form-item label="领用时间" prop="addTime">
        <el-date-picker type="datetime" v-model="dataForm.addTime" :disabled="disabled"
                        placeholder="领用时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="领取类型" prop="type">
        <el-radio-group v-model="dataForm.type" :disabled="disabled">
          <el-radio :label="0">平台发放</el-radio>
          <el-radio :label="1">自动发放</el-radio>
          <el-radio :label="2">领券中心领取</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="状态" prop="status">
        <el-radio-group v-model="dataForm.status" :disabled="disabled">
          <el-radio :label="0">未使用</el-radio>
          <el-radio :label="1">已使用</el-radio>
          <el-radio :label="2">过期</el-radio>
        </el-radio-group>
      </el-form-item>
      <el-form-item label="使用时间" prop="usedTime">
        <el-date-picker type="datetime" v-model="dataForm.usedTime" :disabled="disabled"
                        placeholder="领用时间"></el-date-picker>
      </el-form-item>
      <el-form-item label="订单编码" prop="orderId">
        <el-input v-model="dataForm.orderSn" :disabled="disabled" placeholder="使用的订单编码"></el-input>
      </el-form-item>
    </el-form>
    <span slot="footer" class="dialog-footer">
      <el-button @click="visible = false">取消</el-button>
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
        userName: '',
        title: '',
        addTime: '',
        type: '',
        status: '',
        usedTime: '',
        orderSn: ''
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
            url: `/mall/usercoupon/info/${this.dataForm.id}`,
            method: 'get'
          }).then(({data}) => {
            if (data && data.code === 0) {
              this.dataForm = data.usercoupon
            }
          })
        }
      })
    }
  }
}
</script>
