import os
import json
from flask import Flask,abort,request
from flask_restplus import Resource, Api, fields
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from marshmallow_sqlalchemy import ModelSchema


app = Flask(__name__)
api = Api(app, version='1.0',title='Docker-Training-Assignment', api_spec_url='/')
app.config['SQLALCHEMY_DATABASE_URI'] = os.getenv("SQLALCHEMY_DATABASE_URI")
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)


user = api.model('User', {
    'username': fields.String
})
resource_fields = api.model('User', {
    'user_id': fields.Integer,
    'username': fields.String
}
)
#models
class User(db.Model):
    user_id = db.Column(db.Integer, primary_key=True,  autoincrement=True)
    username = db.Column(db.String(128))

class UserSchema(ModelSchema):
    class Meta:
        model = User
        sqla_session = db.session


#API
class UserHandler(Resource):

    @api.marshal_list_with(resource_fields)
    def get(self, user_id):
        user = User.query \
        .order_by(User.username) \
        .filter(User.user_id==user_id)\
        .one_or_none()
        return user


#API
class UserHandlerUser(Resource):

    @api.marshal_list_with(resource_fields)
    def get(self):
        user = User.query \
        .order_by(User.username) \
        .all()
        return user

    @api.expect(user, validate=True)
    def post(self):
        user = request.get_json()
        username = user.get('username')

        existing_user = User.query \
            .filter(User.username == username) \
            .one_or_none()

    # Can we insert this user?
        if existing_user is None:
            # Add the person to the database
            new_user = User(username=username)
            db.session.add(new_user)
            db.session.commit()

            return  201

        # Otherwise, nope, person exists already
        else:
            abort(409, f'Username {username} exists already')


api.add_resource(UserHandler, '/api/users/<int:user_id>/', endpoint = 'users')
api.add_resource(UserHandlerUser, '/api/users/', endpoint = 'users_list_all')
